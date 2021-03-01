{ lib, fetchFromGitHub
, python, buildPythonPackage, isPy27
, pygame, pyglet, pysdl2, six
}:

buildPythonPackage rec {
  pname = "pytmx";
  version = "3.24.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    # The release was not git tagged.
    owner = "bitcraft";
    repo = "PyTMX";
    rev = "eb96efea30d57b731654b2a167d86b8b553b147d";
    sha256 = "1g1j4w75zw76p5f8m5v0hdigdlva2flf0ngyk8nvqcwzcl5vq5wc";
  };

  propagatedBuildInputs = [ pygame pyglet pysdl2 six ];

  checkPhase = ''
    # Change into the test directory due to a relative resource path.
    cd tests/pytmx
    ${python.interpreter} -m unittest test_pytmx
  '';

  meta = with lib; {
    homepage = "https://github.com/bitcraft/PyTMX";
    description = "Python library to read Tiled Map Editor's TMX maps";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ oxzi ];
  };
}
