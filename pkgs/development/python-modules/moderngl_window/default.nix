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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "moderngl";
    repo = pname;
    rev = version;
    sha256 = "1p03j91pk2bwycd13p0qi8kns1sf357180hd2mkaip8mfaf33x3q";
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
