{ lib, fetchFromGitHub, isPy3k, buildPythonPackage, pygame, pyglet, pysdl2, six }:

buildPythonPackage rec {
  pname = "pytmx";
  version = "3.21.7";

  src = fetchFromGitHub {
    # The release was not git tagged.
    owner = "bitcraft";
    repo = "PyTMX";
    rev = "38519b94ab9a2db7cacb8e18de4d83750ec6fac2";
    sha256 = "0p2gc6lgian1yk4qvhbkxfkmndf9ras70amigqzzwr02y2jvq7j8";
  };

  propagatedBuildInputs = [ pygame pyglet pysdl2 six ];

  # The tests are failing for Python 2.7.
  doCheck = isPy3k;
  checkPhase = ''
    # The following test imports an example file from the current working
    # directory. Thus, we're cd'ing into the test directory.

    cd tests/
    python -m unittest test_pytmx
  '';

  meta = with lib; {
    homepage = "https://github.com/bitcraft/PyTMX";
    description = "Python library to read Tiled Map Editor's TMX maps";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ geistesk ];
  };
}
