{ lib, fetchPypi, buildPythonPackage, aiofile, anyio, typing-extensions }:

buildPythonPackage rec {
  pname = "aiopath";
  version = "0.5.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r0xnba1vz3iyrqkhkrckkrphnzblvsms9pvk8krm2q9vl0r8byy";
  };

  propagatedBuildInputs = [
    aiofile
    anyio
    typing-extensions
  ];

  # no tests available
  #doCheck = false;
  #pythonImportsCheck = [ "pychromecast" ];

  meta = with lib; {
    description = "Async pathlib for Python";
    homepage    = "https://github.com/alexdelorenzo/aiopath";
    license     = licenses.lgpl3Only;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms   = platforms.unix;
  };
}
