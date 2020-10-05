{ stdenv, fetchPypi, buildPythonPackage, pythonOlder, aiohttp }:

buildPythonPackage rec {
  pname = "pysqueezebox";
  version = "0.5.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6c4ea57da2160feb753f58025a4c0fb34716d5d3cfb8518787b4268523cae2e";
  };

  propagatedBuildInputs = [
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
