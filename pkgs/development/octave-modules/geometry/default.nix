{
  buildOctavePackage,
  lib,
  fetchzip,
  matgeom,
  stdenv,
}:

buildOctavePackage rec {
  pname = "geometry";
  version = "4.1.0";

  src = fetchzip {
    url = "https://downloads.sourceforge.net/project/octave/Octave%20Forge%20Packages/Individual%20Package%20Releases/geometry-${version}.tar.gz";
    sha256 = "sha256-Gru+wDm8TzAMrN49Jj7d7vj7sUrxPTbGbwmterwQAAw";
  };

  requiredOctavePackages = [
    matgeom
  ];

  meta = with lib; {
    homepage = "https://gnu-octave.github.io/packages/geometry/";
    license = with licenses; [
      gpl3Plus
      boost
    ];
    # Build error on macOS
    # ./martinez.h:40:30: error: no template named 'binary_function'; did you mean '__binary_function'?
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Library for extending MatGeom functionality";
  };
}
