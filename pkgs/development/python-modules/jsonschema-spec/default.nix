{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, pathable
, poetry-core
, pytestCheckHook
, pythonOlder
, pyyaml
, referencing
, requests
, responses
, typing-extensions
}:

buildPythonPackage rec {
  pname = "jsonschema-spec";
  version = "0.2.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-cPGORXGOZK5JRhlSAOcvhC955PZj0Zr+EpCy/yQBaAU=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonschema
    pathable
    pyyaml
    referencing
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    responses
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsonschema_spec"
  ];

  meta = with lib; {
    changelog = "https://github.com/p1c2u/jsonschema-spec/releases/tag/${version}";
    description = "JSONSchema Spec with object-oriented paths";
    homepage = "https://github.com/p1c2u/jsonschema-spec";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
