{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "node-semver";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "podhmo";
    repo = "python-node-semver";
    rev = "refs/tags/${version}";
    hash = "sha256-Ncl+RUvy9G9lF3EzLz2HfiDB02tEgAlZ34Wbn4mlF6Y=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nodesemver" ];

  meta = with lib; {
    changelog = "https://github.com/podhmo/python-node-semver/blob/${version}/CHANGES.txt";
    description = "A port of node-semver";
    homepage = "https://github.com/podhmo/python-semver";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
