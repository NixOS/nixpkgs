{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "python-bidi";
  version = "0.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "U0f3HoKz6Zdtxlfwne0r/jm6jWd3yoGlssVsMBIcSW4=";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    homepage = "https://github.com/MeirKriheli/python-bidi";
    description = "Pure python implementation of the BiDi layout algorithm";
    mainProgram = "pybidi";
    platforms = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
