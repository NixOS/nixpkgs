{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f9b4856d46ba1f0c850f4e84b264a9a8b4460acb20e865ec00978ad9fbaa4cf";
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
