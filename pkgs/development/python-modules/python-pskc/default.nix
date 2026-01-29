{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  cryptography,
  defusedxml,
  lxml,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  signxml,
}:

buildPythonPackage rec {
  pname = "python-pskc";
  version = "1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arthurdejong";
    repo = "python-pskc";
    tag = version;
    hash = "sha256-WBpS0EJA4arAn7O47ZHq3sBOd9D4tjYZKIi24xX5Hvs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    python-dateutil
  ];

  optional-dependencies = {
    defuse = [ defusedxml ];
    lxml = [ lxml ];
    signature = [ signxml ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    export TZ=Europe/Amsterdam
  '';

  pythonImportsCheck = [ "pskc" ];

  meta = {
    changelog = "https://github.com/arthurdejong/python-pskc/releases/tag/${version}";
    description = "Python module for handling PSKC files";
    homepage = "https://github.com/arthurdejong/python-pskc";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
