{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdurl";
  version = "0.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    hash = "sha256-wxV8DKeTwKpFTUBuGTQXaVHc0eW1//Y+2V8Kgs85TDM=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdurl" ];

  meta = with lib; {
    description = "URL utilities for markdown-it";
    homepage = "https://github.com/hukkin/mdurl";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
