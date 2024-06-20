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
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "GreyNoise-Intelligence";
    repo = "pygreynoise";
    rev = "refs/tags/v${version}";
    hash = "sha256-jsLvq0GndprdYL5mxHDRtZmNkeKT/rIV+dAnRPEmsV8=";
  };

  propagatedBuildInputs = [
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
    changelog = "https://github.com/GreyNoise-Intelligence/pygreynoise/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
