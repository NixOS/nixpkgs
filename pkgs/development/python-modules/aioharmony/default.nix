{ lib, buildPythonPackage, fetchPypi, isPy3k, slixmpp, async-timeout, aiohttp }:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c8f6e3b776e4e7eba5a1d2ae739aac6a1dd558a7f15951c34ffe0ee28f7f538";
  };

  disabled = !isPy3k;

  #aioharmony does not seem to include tests
  doCheck = false;

  pythonImportsCheck = [ "aioharmony.harmonyapi" "aioharmony.harmonyclient" ];

  propagatedBuildInputs = [ slixmpp async-timeout aiohttp ];

  meta = with lib; {
    homepage = "https://github.com/ehendrix23/aioharmony";
    description =
      "Asyncio Python library for connecting to and controlling the Logitech Harmony";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
