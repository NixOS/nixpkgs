{ lib, fetchFromGitHub, isPy3k, buildPythonPackage, pygame, pyglet, pysdl2, six }:

buildPythonPackage rec {
  pname = "pytmx";
  version = "3.22.0";

  src = fetchFromGitHub {
    # The release was not git tagged.
    owner = "bitcraft";
    repo = "PyTMX";
    rev = "187fd429dadcdc5828e78e6748a983aa1434e4d2";
    sha256 = "0480pr61v54bwdyzb983sk0fqkyfbcgrdn8k11yf1yck4zb119gc";
  };

  propagatedBuildInputs = [ pygame pyglet pysdl2 six ];

  checkPhase = ''
    python -m unittest tests.pytmx.test_pytmx
  '';

  meta = with lib; {
    homepage = "https://github.com/bitcraft/PyTMX";
    description = "Python library to read Tiled Map Editor's TMX maps";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ geistesk ];
  };
}
