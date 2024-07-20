{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "hatch-nodejs-version";
  version = "0.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agoose77";
    repo = "hatch-nodejs-version";
    rev = "refs/tags/v${version}";
    hash = "sha256-hknlb11DCe+b55CfF3Pr62ccWPxVrjQ197ZagSiH/zU=";
  };

  propagatedBuildInputs = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hatch_nodejs_version" ];

  meta = with lib; {
    description = "Plugins for dealing with NodeJS versions";
    homepage = "https://github.com/agoose77/hatch-nodejs-version";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
