{ stdenv
, buildPythonPackage
, fetchurl
, nose
}:

buildPythonPackage rec {
  version = "1.2.8";
  pname = "minimock";

  src = fetchurl {
    url = "https://bitbucket.org/jab/minimock/get/${version}.zip";
    sha256 = "c88fa8a7120623f23990a7f086a9657f6ced09025a55e3be8649a30b4945441a";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    ./test
  '';

  meta = with stdenv.lib; {
    description = "A minimalistic mocking library for python";
    homepage = https://pypi.python.org/pypi/MiniMock;
    license = licenses.mit;
  };

}
