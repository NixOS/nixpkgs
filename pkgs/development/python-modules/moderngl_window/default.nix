{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, numpy
, moderngl
, pyglet
, pillow
, pyrr
, pytest
}:

buildPythonPackage rec {
  pname = "moderngl_window";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "moderngl";
    repo = pname;
    rev = version;
    sha256 = "054w77lyc2nc0dyx76zsrbq2b3xbywdijhb62b2qqm99ldr1k1x5";
  };

  propagatedBuildInputs = [ numpy moderngl pyglet pillow pyrr ];

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
