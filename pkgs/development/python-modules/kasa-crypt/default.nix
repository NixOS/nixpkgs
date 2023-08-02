{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, poetry-core
, pytestCheckHook
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "kasa-crypt";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "kasa-crypt";
    rev = "refs/tags/v${version}";
    hash = "sha256-w0LdGPVsxTi7jlfS/HSBEZdjL9ZKclucnBVViwrVC6Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=kasa_crypt --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "kasa_crypt"
  ];

  meta = with lib; {
    description = "Fast kasa crypt";
    homepage = "https://github.com/bdraco/kasa-crypt";
    changelog = "https://github.com/bdraco/kasa-crypt/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
