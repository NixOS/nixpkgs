{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  requests,
  httmock,
}:

buildPythonPackage rec {
  pname = "freesms";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bfontaine";
    repo = "freesms";
    tag = "v${version}";
    hash = "sha256-5f5amXH6VVppX9/9DhILdBU8w/6n67EUgBy/zgTEUCM=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    httmock
  ];

  pythonImportsCheck = [ "freesms" ];

  meta = {
    description = "Python interface for Free Mobile SMS API";
    homepage = "https://github.com/bfontaine/freesms";
    changelog = "https://github.com/bfontaine/freesms/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
