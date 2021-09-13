{ stdenv, lib, fetchFromGitHub
, autoreconfHook, autoconf-archive, pkg-config, doxygen, perl
, openssl, json_c, curl, libgcrypt
, cmocka, uthash, ibm-sw-tpm2, iproute2, procps, which
}:
let
  # Avoid a circular dependency on Linux systems (systemd depends on tpm2-tss,
  # tpm2-tss tests depend on procps, procps depends on systemd by default). This
  # needs to be conditional based on isLinux because procps for other systems
  # might not support the withSystemd option.
  procpsWithoutSystemd = procps.override { withSystemd = false; };
  procps_pkg = if stdenv.isLinux then procpsWithoutSystemd else procps;
in

stdenv.mkDerivation rec {
  pname = "tpm2-tss";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = pname;
    rev = version;
    sha256 = "106yhsjwjadxsl9dqxywg287mdwsksman02hdalhav18vcnvnlpj";
  };

  nativeBuildInputs = [
    autoreconfHook autoconf-archive pkg-config doxygen perl
  ];
  buildInputs = [ openssl json_c curl libgcrypt ];
  checkInputs = [
    cmocka uthash ibm-sw-tpm2 iproute2 procps_pkg which
  ];

  preAutoreconf = "./bootstrap";

  enableParallelBuilding = true;

  patches = [
    # Do not rely on dynamic loader path
    # TCTI loader relies on dlopen(), this patch prefixes all calls with the output directory
    ./no-dynamic-loader-path.patch
  ];

  postPatch = ''
    patchShebangs script
    substituteInPlace src/tss2-tcti/tctildr-dl.c \
      --replace '@PREFIX@' $out/lib/
    substituteInPlace ./test/unit/tctildr-dl.c \
      --replace '@PREFIX@' $out/lib
  '';

  configureFlags = [
    "--enable-unit"
    "--enable-integration"
  ];

  doCheck = true;
  preCheck = ''
    # Since we rewrote the load path in the dynamic loader for the TCTI
    # The various tcti implementation should be placed in their target directory
    # before we could run tests
    installPhase
    # install already done, dont need another one
    dontInstall=1
  '';

  postInstall = ''
    # Do not install the upstream udev rules, they rely on specific
    # users/groups which aren't guaranteed to exist on the system.
    rm -R $out/lib/udev
  '';

  meta = with lib; {
    description = "OSS implementation of the TCG TPM2 Software Stack (TSS2)";
    homepage = "https://github.com/tpm2-software/tpm2-tss";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
