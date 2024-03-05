{ lib
, buildPythonPackage
, environs
, fetchFromGitHub
, poetry-core
, pytest-mock
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
, tornado
}:

buildPythonPackage rec {
  pname = "deezer-python";
  version = "6.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = "deezer-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-pzEXiWKMP2Wqme/pqfTMHxWH/4YcCS6u865wslHrUqI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=deezer" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    environs
    pytest-mock
    pytest-vcr
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    requests
    tornado
  ];

  pythonImportsCheck = [
    "deezer"
  ];

  disabledTests = [
    # JSONDecodeError issue
    "test_get_user_flow"
    "test_with_language_header"
  ];

  meta = with lib; {
    description = "Python wrapper around the Deezer API";
    homepage = "https://github.com/browniebroke/deezer-python";
    changelog = "https://github.com/browniebroke/deezer-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
  };
}
