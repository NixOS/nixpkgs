{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  ansimarkup,
  cachetools,
  colorama,
  click-default-group,
  click-repl,
  dict2xml,
  hatchling,
  jinja2,
  more-itertools,
  requests,
  six,
  pytestCheckHook,
  mock,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "greynoise";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "GreyNoise-Intelligence";
    repo = "pygreynoise";
    tag = "v${version}";
    hash = "sha256-wJDO666HC3EohfR+LbG5F0Cp/eL7q4kXniWhJfc7C3s=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    click
    ansimarkup
    cachetools
    colorama
    click-default-group
    click-repl
    dict2xml
    jinja2
    more-itertools
    requests
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "greynoise" ];

  meta = with lib; {
    description = "Python3 library and command line for GreyNoise";
    mainProgram = "greynoise";
    homepage = "https://github.com/GreyNoise-Intelligence/pygreynoise";
    changelog = "https://github.com/GreyNoise-Intelligence/pygreynoise/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
