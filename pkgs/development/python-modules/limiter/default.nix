{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, token-bucket
}:

buildPythonPackage rec {
  pname = "limiter";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "alexdelorenzo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-h3XiCR/8rcCBwdhO6ExrrUE9piba5mssad3+t41scSk=";
  };

  propagatedBuildInputs = [
    token-bucket
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "token-bucket==0.2.0" "token-bucket>=0.2.0"
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "limiter"
  ];

  meta = with lib; {
    description = "Python rate-limiting, thread-safe and asynchronous decorators and context managers";
    homepage = "https://github.com/alexdelorenzo/limiter";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
