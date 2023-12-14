{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, poetry-core

# optional-dependencies
, furo
, myst-parser
, sphinx-autobuild
, sphinxHook

# tests
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiohappyeyeballs";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiohappyeyeballs";
    rev = "refs/tags/v${version}";
    hash = "sha256-LMvELnN6Sy6DssXfH6fQ84N2rhdjqB8AlikTMidrjT4=";
  };

  postPatch = ''
    sed -i '/addopts/d' pyproject.toml
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    poetry-core
  ] ++ passthru.optional-dependencies.docs;

  passthru.optional-dependencies = {
    docs = [
      furo
      myst-parser
      sphinx-autobuild
      sphinxHook
    ];
  };

  pythonImportsCheck = [
    "aiohappyeyeballs"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # https://github.com/bdraco/aiohappyeyeballs/issues/30
    "tests/test_impl.py"
  ];

  meta = with lib; {
    description = "Happy Eyeballs for pre-resolved hosts";
    homepage = "https://github.com/bdraco/aiohappyeyeballs";
    changelog = "https://github.com/bdraco/aiohappyeyeballs/blob/${src.rev}/CHANGELOG.md";
    license = licenses.psfl;
    maintainers = with maintainers; [ hexa ];
  };
}
