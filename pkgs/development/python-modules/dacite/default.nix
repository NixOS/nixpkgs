{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dacite";
  version = "1.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "konradhalas";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-lvObQ+jyBH2s4GOwyDXEAYmG7ZGQN9WDqL8ftNItPCQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-autosave --benchmark-json=benchmark.json" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dacite"
  ];

  disabledTestPaths = [
    "tests/performance"
  ];

  meta = with lib; {
    description = "Python helper to create data classes from dictionaries";
    homepage = "https://github.com/konradhalas/dacite";
    changelog = "https://github.com/konradhalas/dacite/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
