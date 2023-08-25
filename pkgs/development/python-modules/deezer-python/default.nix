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
  version = "6.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9uFKrr0C/RIklpW5KZj8pSv4oEibzSaAJWnTwYKyxD8=";
  };

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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=deezer" ""
  '';

  pythonImportsCheck = [
    "deezer"
  ];

  meta = with lib; {
    description = "Python wrapper around the Deezer API";
    homepage = "https://github.com/browniebroke/deezer-python";
    changelog = "https://github.com/browniebroke/deezer-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
  };
}
