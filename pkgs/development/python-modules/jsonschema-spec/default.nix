{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, jsonschema
, pathable
, pyyaml
, requests
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonschema-spec";
  version = "0.1.6";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-rXE7CNIKNbKcPoyiDM5qqN/E+q8L/tsMZWEetpUZJJw=";
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
    requests
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
