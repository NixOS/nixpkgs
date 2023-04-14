{ buildOctavePackage
, lib
, fetchFromGitHub
, gfortran
, lapack, blas
, autoreconfHook
}:

buildOctavePackage rec {
  pname = "control";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "pkg-control";
    rev = "${pname}-${version}";
    sha256 = "sha256-isUHovpknIFclspHjAtUxGLkrdxitdWSnQMED9n+R3s=";
  };

  # Running autoreconfHook inside the src directory fixes a compile issue about
  # the config.h header for control missing.
  # This is supposed to be handled by control's top-level Makefile, but does not
  # appear to be working. This manually forces it instead.
  preAutoreconf = ''
    pushd src
  '';

  postAutoreconf = ''
    popd
  '';

  nativeBuildInputs = [
    gfortran
    autoreconfHook
  ];

  buildInputs = [
    lapack blas
  ];

  meta = with lib; {
    homepage = "https://gnu-octave.github.io/packages/control/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Computer-Aided Control System Design (CACSD) Tools for GNU Octave, based on the proven SLICOT Library";
  };
}
