{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "awacs";
  version = "2.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mdU88KH1bxsJROG70tS2FYvRSrlHlBK9GKxR4gg1OFw=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "awacs" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "AWS Access Policy Language creation library";
    homepage = "https://github.com/cloudtools/awacs";
    changelog = "https://github.com/cloudtools/awacs/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
}
