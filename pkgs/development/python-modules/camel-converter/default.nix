{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "camel-converter";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanders41";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-SUuSaQU6o2OtjDNrDcO3nS0EZH2ammEkP7AEp4H5ysI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=camel_converter --cov-report term-missing" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  passthru.optional-dependencies = {
    pydantic = [
      pydantic
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.pydantic;

  pythonImportsCheck = [
    "camel_converter"
  ];

  meta = with lib; {
    description = "Client for the Meilisearch API";
    homepage = "https://github.com/sanders41/camel-converter";
    changelog = "https://github.com/sanders41/camel-converter/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
