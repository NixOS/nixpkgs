{ stdenv, lib, fetchFromGitHub, runCommand
, autoreconfHook, autoconf-archive, pkg-config, doxygen, perl
, openssl, json_c, curl, libgcrypt
, cmocka, uthash, ibm-sw-tpm2, iproute2, procps, which
, libuuid
}:
let
  # Avoid a circular dependency on Linux systems (systemd depends on tpm2-tss,
  # tpm2-tss tests depend on procps, procps depends on systemd by default). This
  # needs to be conditional based on isLinux because procps for other systems
  # might not support the withSystemd option.
  procpsWithoutSystemd = procps.override { withSystemd = false; };
  procps_pkg = if stdenv.isLinux then procpsWithoutSystemd else procps;

  # Configure script expects tools from shadow but we are not actually using
  # them. Instead of patching the build scripts, just add fake executables
  # to native build inputs. These would fail the build if called from both POSIX
  # shell and via native exec system call (albeit for different reasons).
  # https://github.com/tpm2-software/tpm2-tss/blob/6c46325b466f35d40c2ed1043bfdfcfb8a367a34/configure.ac#L666-L675
  # https://github.com/tpm2-software/tpm2-tss/blob/6c46325b466f35d40c2ed1043bfdfcfb8a367a34/Makefile.am#L880-L898
  fakeShadow = runCommand "fake-shadow" { } ''
    mkdir -p -- "$out"/bin
    for executable in "$out"/bin/{useradd,groupadd}; do
      printf '#!/bin/sh -\nexit 1' >"$executable"
      chmod +x -- "$executable"
    done
  '';
in

stdenv.mkDerivation rec {
  pname = "tpm2-tss";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = pname;
    rev = version;
    hash = "sha256-BP28utEUI9g1VNv3lCXuiKrDtEImFQxxZfIjLiE3Wr8=";
  };

  outputs = [ "out" "man" "dev" ];

  nativeBuildInputs = [
    autoreconfHook autoconf-archive pkg-config doxygen perl
    fakeShadow
  ];

  buildInputs = [
    openssl json_c curl libgcrypt uthash libuuid
  ]
  # cmocka is checked in the configure script
  # when unit and/or integration testing is enabled
  # cmocka doesn't build with pkgsStatic, and we don't need it anyway
  # when tests are not run
  ++ lib.optional doInstallCheck cmocka;

  nativeInstallCheckInputs = [
    cmocka which openssl procps_pkg iproute2 ibm-sw-tpm2
  ];

  strictDeps = true;
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
      --replace '@PREFIX@' $out/lib/
    substituteInPlace ./bootstrap \
      --replace 'git describe --tags --always --dirty' 'echo "${version}"'
  '';

  configureFlags = lib.optionals doInstallCheck [
    "--enable-unit"
    "--enable-integration"
  ];

  postInstall = ''
    # Do not install the upstream udev rules, they rely on specific
    # users/groups which aren't guaranteed to exist on the system.
    rm -R $out/lib/udev
  '';

  doCheck = false;
  doInstallCheck = stdenv.buildPlatform == stdenv.hostPlatform;
  # Since we rewrote the load path in the dynamic loader for the TCTI
  # The various tcti implementation should be placed in their target directory
  # before we could run tests, so we make turn checkPhase into installCheckPhase
  installCheckTarget = "check";

  meta = with lib; {
    description = "OSS implementation of the TCG TPM2 Software Stack (TSS2)";
    homepage = "https://github.com/tpm2-software/tpm2-tss";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ baloo ];
  };
}
