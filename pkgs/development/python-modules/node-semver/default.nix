{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "node-semver";
  version = "0.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "podhmo";
    repo = "python-node-semver";
    tag = version;
    hash = "sha256-Ncl+RUvy9G9lF3EzLz2HfiDB02tEgAlZ34Wbn4mlF6Y=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nodesemver" ];

  meta = {
    changelog = "https://github.com/podhmo/python-node-semver/blob/${version}/CHANGES.txt";
    description = "Port of node-semver";
    homepage = "https://github.com/podhmo/python-semver";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
