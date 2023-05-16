<<<<<<< HEAD
{ stdenv, lib, fetchFromGitHub, fetchurl
, autoreconfHook, autoconf-archive, pkg-config, doxygen, perl
, openssl, json_c, curl, libgcrypt
, cmocka, uthash, ibm-sw-tpm2, iproute2, procps, which
, shadow, libuuid
=======
{ stdenv, lib, fetchFromGitHub
, autoreconfHook, autoconf-archive, pkg-config, doxygen, perl
, openssl, json_c, curl, libgcrypt
, cmocka, uthash, ibm-sw-tpm2, iproute2, procps, which
, shadow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "4.0.1";
=======
  version = "3.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-75yiKVZrR1vcCwKp4tDO4A9JB0KDM0MXPJ1N85kAaRk=";
=======
    sha256 = "1jijxnvjcsgz5yw4i9fj7ycdnnz90r3l0zicpwinswrw47ac3yy5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "man" "dev" ];

  nativeBuildInputs = [
    autoreconfHook autoconf-archive pkg-config doxygen perl
    shadow
  ];

<<<<<<< HEAD
  buildInputs = [
    openssl json_c curl libgcrypt uthash libuuid
  ]
  # cmocka is checked in the configure script
  # when unit and/or integration testing is enabled
  # cmocka doesn't build with pkgsStatic, and we don't need it anyway
  # when tests are not run
  ++ lib.optional doInstallCheck cmocka;

  nativeInstallCheckInputs = [
=======
  # cmocka is checked / used(?) in the configure script
  # when unit and/or integration testing is enabled
  buildInputs = [ openssl json_c curl libgcrypt uthash ]
    # cmocka doesn't build with pkgsStatic, and we don't need it anyway
    # when tests are not run
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [
    cmocka
  ];

  nativeCheckInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cmocka which openssl procps_pkg iproute2 ibm-sw-tpm2
  ];

  strictDeps = true;
  preAutoreconf = "./bootstrap";

  enableParallelBuilding = true;

  patches = [
    # Do not rely on dynamic loader path
    # TCTI loader relies on dlopen(), this patch prefixes all calls with the output directory
    ./no-dynamic-loader-path.patch
<<<<<<< HEAD
    (fetchurl {
      name = "skip-test-fapi-fix-provisioning-with-template-if-no-certificate-available.patch";
      url = "https://github.com/tpm2-software/tpm2-tss/commit/218c0da8d9f675766b1de502a52e23a3aa52648e.patch";
      sha256 = "sha256-dnl9ZAknCdmvix2TdQvF0fHoYeWp+jfCTg8Uc7h0voA=";
    })
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    patchShebangs script
    substituteInPlace src/tss2-tcti/tctildr-dl.c \
      --replace '@PREFIX@' $out/lib/
    substituteInPlace ./test/unit/tctildr-dl.c \
      --replace '@PREFIX@' $out/lib
<<<<<<< HEAD
    substituteInPlace ./bootstrap \
      --replace 'git describe --tags --always --dirty' 'echo "${version}"'
  '';

  configureFlags = lib.optionals doInstallCheck [
=======
    substituteInPlace ./configure.ac \
      --replace 'm4_esyscmd_s([git describe --tags --always --dirty])' '${version}'
  '';

  configureFlags = lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--enable-unit"
    "--enable-integration"
  ];

<<<<<<< HEAD
=======
  doCheck = true;
  preCheck = ''
    # Since we rewrote the load path in the dynamic loader for the TCTI
    # The various tcti implementation should be placed in their target directory
    # before we could run tests
    installPhase
    # install already done, dont need another one
    dontInstall=1
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    # Do not install the upstream udev rules, they rely on specific
    # users/groups which aren't guaranteed to exist on the system.
    rm -R $out/lib/udev
  '';

<<<<<<< HEAD
  doCheck = false;
  doInstallCheck = stdenv.buildPlatform == stdenv.hostPlatform;
  # Since we rewrote the load path in the dynamic loader for the TCTI
  # The various tcti implementation should be placed in their target directory
  # before we could run tests, so we make turn checkPhase into installCheckPhase
  installCheckTarget = "check";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "OSS implementation of the TCG TPM2 Software Stack (TSS2)";
    homepage = "https://github.com/tpm2-software/tpm2-tss";
    license = licenses.bsd2;
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = with maintainers; [ baloo ];
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
