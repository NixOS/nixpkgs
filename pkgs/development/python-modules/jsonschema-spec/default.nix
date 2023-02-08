{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, jsonschema
, pathable
, pyyaml
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonschema-spec";
  version = "0.1.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-RfkD2fVH9OUTe0XNpHO6brQ4+8zbMpae6AgdeFpYXa8=";
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
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/p1c2u/jsonschema-spec/releases/tag/${version}";
    description = "JSONSchema Spec with object-oriented paths";
    homepage = "https://github.com/p1c2u/jsonschema-spec";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
