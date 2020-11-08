{ stdenv, fetchPypi, buildPythonPackage, pythonOlder, aiohttp }:

buildPythonPackage rec {
  pname = "pysqueezebox";
  version = "0.4.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02d73e98314a63a38c314d40942a0b098fb59d2f08ac39b2627cfa73f785cf0d";
  };

  requiredPythonModules = [
    aiohttp
  ];

  # No tests in the Pypi distribution
  doCheck = false;
  pythonImportsCheck = [ "pysqueezebox" ];

  meta = with stdenv.lib; {
    description = "Asynchronous library to control Logitech Media Server";
    homepage = "https://github.com/rajlaud/pysqueezebox";
    license = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
