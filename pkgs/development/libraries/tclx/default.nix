{ lib
, fetchFromGitHub
, tcl
}:

tcl.mkTclDerivation rec {
  pname = "tclx";
<<<<<<< HEAD
  version = "8.6.2";
=======
  version = "8.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "tclx";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ZYJcaVBM5DQWBFYAcW6fx+ENMWJwHzTOUKYPkLsd6o8=";
=======
    hash = "sha256-HdbuU0IR8q/0g2fIs1xtug4oox/D24C8E2VbEJC5B1A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # required in order for tclx to properly detect tclx.tcl at runtime
  postInstall = let
    majorMinorVersion = lib.versions.majorMinor version;
  in ''
    ln -s $prefix/lib/tclx${majorMinorVersion} $prefix/lib/tclx${majorMinorVersion}/tclx${majorMinorVersion}
  '';

  meta = {
    homepage = "https://github.com/flightaware/tclx";
    description = "Tcl extensions";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ kovirobi fgaz ];
  };
}
