{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "94505026be56652d7a530ab03d89474dc6021019d6b8682281977163b3471ea0";
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
