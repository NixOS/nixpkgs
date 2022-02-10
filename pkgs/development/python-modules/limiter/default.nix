{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, strenum
, token-bucket
}:

buildPythonPackage rec {
  pname = "limiter";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "alexdelorenzo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9EkA7S549JLi6MxAXBC+2euPDrcJjW8IsQzMtij8+hA=";
  };

  propagatedBuildInputs = [
    strenum
    token-bucket
  ];

  # Module has no tests
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
