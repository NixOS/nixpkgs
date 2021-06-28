{ lib
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asynccmd";
  version = "0.2.4";

  # https://github.com/valentinmk/asynccmd/pull/2
  disabled = pythonOlder "3.5" || pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "valentinmk";
    repo = "asynccmd";
    rev = version;
    sha256 = "02sa0k0zgwv0y8k00pd1yh4x7k7xqhdikk2c0avpih1204lcw26h";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asynccmd" ];

  meta = with lib; {
    description = "Asyncio implementation of Cmd Python lib";
    homepage = "https://github.com/valentinmk/asynccmd";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
