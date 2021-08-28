{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "poolsense";
  version = "0.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09y4fq0gdvgkfsykpxnvmfv92dpbknnq5v82spz43ak6hjnhgcyp";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "poolsense" ];

  meta = with lib; {
    description = "Python module to access PoolSense device";
    homepage = "https://github.com/haemishkyd/poolsense";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
