{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  hatchling,
}:

buildPythonPackage rec {
  pname = "hatch-nodejs-version";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agoose77";
    repo = "hatch-nodejs-version";
    tag = "v${version}";
    hash = "sha256-Oe07HFzhhnAGTWM51xSgRmpJgIZg0oMIxkmMxKRPMwI=";
  };

  propagatedBuildInputs = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hatch_nodejs_version" ];

  meta = {
    description = "Plugins for dealing with NodeJS versions";
    homepage = "https://github.com/agoose77/hatch-nodejs-version";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
