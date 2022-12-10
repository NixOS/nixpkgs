{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, numpy
, moderngl
, pyglet
, pillow
, pyrr
, glcontext
}:

buildPythonPackage rec {
  pname = "moderngl_window";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "moderngl";
    repo = pname;
    rev = version;
    sha256 = "12a5nl01c9b1ww7sj7i02xa7zmlrgg8jvi8cz004hw98kjcs9li8";
  };

  propagatedBuildInputs = [ numpy moderngl pyglet pillow pyrr glcontext ];

  disabled = !isPy3k;

  # Tests need a display to run.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/moderngl/moderngl_window";
    description = "Cross platform helper library for ModernGL making window creation and resource loading simple";
    license = licenses.mit;
    platforms = platforms.linux; # should be mesaPlatforms, darwin build breaks.
    maintainers = with maintainers; [ c0deaddict ];
  };
}
