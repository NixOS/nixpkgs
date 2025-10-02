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
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agoose77";
    repo = "hatch-nodejs-version";
    tag = "v${version}";
    hash = "sha256-Oe07HFzhhnAGTWM51xSgRmpJgIZg0oMIxkmMxKRPMwI=";
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
