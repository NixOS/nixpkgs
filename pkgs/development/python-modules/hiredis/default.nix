{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# tested using
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hiredis";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis-py";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-OT8zFEHKSAebXV+VzagZDJRPidAhSrqvD2/F1YezVGs=";
  };

  pythonImportsCheck = [
    "hiredis"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf hiredis
  '';

  meta = with lib; {
    description = "Wraps protocol parsing code in hiredis, speeds up parsing of multi bulk replies";
    homepage = "https://github.com/redis/hiredis-py";
    changelog = "https://github.com/redis/hiredis-py/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}

