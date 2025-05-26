{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cfgv";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "cfgv";
    tag = "v${version}";
    hash = "sha256-P02j53dltwdrlUBG89AI+P2GkXYKTVrQNF15rZt58jw=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cfgv" ];

  meta = with lib; {
    description = "Validate configuration and produce human readable error messages";
    homepage = "https://github.com/asottile/cfgv";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
