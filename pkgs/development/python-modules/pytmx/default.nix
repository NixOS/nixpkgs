{ lib, fetchFromGitHub
, python, buildPythonPackage, isPy27
, pygame, pyglet, pysdl2, six
}:

buildPythonPackage rec {
  pname = "pytmx";
  version = "3.25";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "bitcraft";
    repo = "PyTMX";
    rev = version;
    sha256 = "0v07zhvzvl2qcqhjzgfzm8hgayq38gaqcxxkyhlq9n0hlk93nm97";
  };

  propagatedBuildInputs = [ pygame pyglet pysdl2 six ];

  pythonImportsCheck = [
    "pytmx.pytmx"
    "pytmx.util_pygame"
    "pytmx.util_pyglet"
    "pytmx.util_pysdl2"
  ];

  checkPhase = ''
    # Change into the test directory due to a relative resource path.
    cd tests/pytmx
    ${python.interpreter} -m unittest test_pytmx
  '';

  meta = with lib; {
    homepage = "https://github.com/bitcraft/PyTMX";
    description = "Python library to read Tiled Map Editor's TMX maps";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ oxzi ];
  };
}
