{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "plac";
  version = "1.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ialbert";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U3k97YJhQjulYNWcKVx96/5zND5VfsRjA3ZZHWhcDNg=";
  };

  # tests are broken, see https://github.com/ialbert/plac/issues/74
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} doc/test_plac.py

    runHook postCheck
  '';

  pythonImportsCheck = [
    "plac"
  ];

  meta = with lib; {
    description = "Parsing the Command Line the Easy Way";
    homepage = "https://github.com/micheles/plac";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
