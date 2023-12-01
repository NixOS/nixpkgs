{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pyyaml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "configargparse";
  version = "1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    rev = "refs/tags/${version}";
    hash = "sha256-m77MY0IZ1AJkd4/Y7ltApvdF9y17Lgn92WZPYTCU9tA=";
  };

  passthru.optional-dependencies = {
    yaml = [
      pyyaml
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "configargparse"
  ];

  meta = with lib; {
    description = "A drop-in replacement for argparse";
    homepage = "https://github.com/bw2/ConfigArgParse";
    changelog = "https://github.com/bw2/ConfigArgParse/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
  };
}
