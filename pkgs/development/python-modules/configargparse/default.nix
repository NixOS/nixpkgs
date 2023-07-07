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
  version = "1.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    rev = "refs/tags/${version}";
    hash = "sha256-nhsbgyoIsYyrW20j4X4RosMJU/B+j7Z5YbebmZCLW4I=";
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
