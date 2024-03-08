{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, urllib3
, six
, certifi
, python-dateutil
, asn1crypto
}:

buildPythonPackage rec {
  pname = "ionoscloud";
  version = "6.1.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash= "sha256-QQNDqKZ+X+w5vHFXr793QqRjShNBZ182DyD3fUUxqkc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ urllib3 six certifi python-dateutil asn1crypto ];

  # upstream only has codecoverage tests, but no actual tests to go with them
  doCheck = false;

  pythonImportsCheck = [
    "ionoscloud"
  ];

  meta = with lib; {
    homepage = "https://github.com/ionos-cloud/sdk-python";
    description = "Python API client for ionoscloud";
    changelog = "https://github.com/ionos-cloud/sdk-python/blob/v${version}/docs/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexchen ];
  };
}
