{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp }:

buildPythonPackage rec {
  pname = "pysqueezebox";
  version = "0.5.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93e6a3824b560d4ea2b2e5f0a67fdf3b309b6194fbf9927e44fc0d12c7fdc6c0";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # No tests in the Pypi distribution
  doCheck = false;
  pythonImportsCheck = [ "pysqueezebox" ];

  meta = with lib; {
    description = "Asynchronous library to control Logitech Media Server";
    homepage = "https://github.com/rajlaud/pysqueezebox";
    license = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
