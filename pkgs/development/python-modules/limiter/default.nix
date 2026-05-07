{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  strenum,
  token-bucket,
}:

buildPythonPackage rec {
  pname = "limiter";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alexdelorenzo";
    repo = "limiter";
    rev = "v${version}";
    hash = "sha256-2Et4ozVf9t+tp2XtLbDk/LgLIU+jQAEAlU8hA5lpxdk=";
  };

  propagatedBuildInputs = [
    strenum
    token-bucket
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "limiter" ];

  meta = {
    description = "Python rate-limiting, thread-safe and asynchronous decorators and context managers";
    homepage = "https://github.com/alexdelorenzo/limiter";
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
