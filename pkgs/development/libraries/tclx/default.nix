{ lib
, fetchFromGitHub
, tcl
}:

tcl.mkTclDerivation rec {
  pname = "tclx";
  version = "8.6.2";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "tclx";
    rev = "v${version}";
    hash = "sha256-ZYJcaVBM5DQWBFYAcW6fx+ENMWJwHzTOUKYPkLsd6o8=";
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
