{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, token-bucket
}:

buildPythonPackage rec {
  pname = "limiter";
  version = "0.1.2";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alexdelorenzo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cdqw08qw3cid1yjknlh4hqfl46xh4madkjrl7sxk2c1pbwils8r";
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
