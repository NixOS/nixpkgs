{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.1.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "41b573cf33f64a8f8f3400d0a7faf48e1888582b6f6e02b82b9bd4f0bf7497ce";
  };

  # tests are not included in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "httptools" ];

  meta = with lib; {
    description = "A collection of framework independent HTTP protocol utils";
    homepage = "https://github.com/MagicStack/httptools";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
