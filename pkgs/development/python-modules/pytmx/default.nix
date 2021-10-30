{ lib, fetchFromGitHub
, python, buildPythonPackage, isPy27
, pygame, pyglet, pysdl2, six
}:

buildPythonPackage rec {
  pname = "pytmx";
  version = "3.27";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "bitcraft";
    repo = "PyTMX";
    # Release was not tagged.
    rev = "5bb094c45e648d1de6c9ba8d8c8f31f7b83478e1";
    sha256 = "0kpd39sr2ggwzh7nd3f5801mgwm57rzrrkqcgbcypdm8l2ayga3b";
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
