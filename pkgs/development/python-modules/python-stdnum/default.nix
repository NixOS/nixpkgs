{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  zeep,
}:

buildPythonPackage rec {
  pname = "python-stdnum";
  version = "2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arthurdejong";
    repo = "python-stdnum";
    tag = version;
    hash = "sha256-9m4tO9TX9lV4V3wTkMFDj0Mc+jl4bKsHM/adeF3cBTE=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    SOAP = [ zeep ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "stdnum" ];

  meta = with lib; {
    description = "Python module to handle standardized numbers and codes";
    homepage = "https://arthurdejong.org/python-stdnum/";
    changelog = "https://github.com/arthurdejong/python-stdnum/blob/${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ johbo ];
  };
}
