{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp }:

buildPythonPackage rec {
  pname = "pysqueezebox";
  version = "0.6.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qc6ffWk62EF+IOLb2XVWtDrrZ0LVs7VtxJG1qrrUPPg=";
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
