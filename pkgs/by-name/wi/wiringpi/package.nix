{
  lib,
  stdenv,
  symlinkJoin,
  fetchFromGitHub,
  libxcrypt,
}:

let
  version = "3.16";
  srcAll = fetchFromGitHub {
    owner = "WiringPi";
    repo = "WiringPi";
    tag = version;
    hash = "sha256-NBHmRA+6Os6/IpW8behbgpVjtN8QF9gkffXU2ZVC8ts=";
  };
  mkSubProject =
    {
      subprj, # The only mandatory argument
      buildInputs ? [ ],
      src ? srcAll,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "wiringpi-${subprj}";
      inherit version src;
      sourceRoot = "${src.name}/${subprj}";
      inherit buildInputs;
      # Remove (meant for other OSs) lines from Makefiles
      preInstall = ''
        sed -i "/chown root/d" Makefile
        sed -i "/chmod/d" Makefile
      '';
      makeFlags = [
        "DESTDIR=${placeholder "out"}"
        "PREFIX=/."
        # On NixOS we don't need to run ldconfig during build:
        "LDCONFIG=echo"
      ];
    });
  passthru = {
    # Helps nix-update and probably nixpkgs-update find the src of this package
    # automatically.
    src = srcAll;
    inherit mkSubProject;
    wiringPi = mkSubProject {
      subprj = "wiringPi";
      buildInputs = [ libxcrypt ];
    };
    devLib = mkSubProject {
      subprj = "devLib";
      buildInputs = [ passthru.wiringPi ];
    };
    wiringPiD = mkSubProject {
      subprj = "wiringPiD";
      buildInputs = [
        libxcrypt
        passthru.wiringPi
        passthru.devLib
      ];
    };
    gpio = mkSubProject {
      subprj = "gpio";
      buildInputs = [
        libxcrypt
        passthru.wiringPi
        passthru.devLib
      ];
    };
  };
in

symlinkJoin {
  name = "wiringpi-${version}";
  inherit passthru;
  paths = [
    passthru.wiringPi
    passthru.devLib
    passthru.wiringPiD
    passthru.gpio
  ];
  meta = {
    description = "Gordon's Arduino wiring-like WiringPi Library for the Raspberry Pi (Unofficial Mirror for WiringPi bindings)";
    homepage = "https://github.com/WiringPi/WiringPi";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      doronbehar
      ryand56
    ];
    platforms = lib.platforms.linux;
  };
}
