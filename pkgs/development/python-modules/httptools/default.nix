{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LJqTDDeLPRXWtpX7levP+BpzlbT5d1xPEKB2vrCywf8=";
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
