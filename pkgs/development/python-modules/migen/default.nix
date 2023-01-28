{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, colorama
}:

buildPythonPackage rec {
  pname = "migen";
  version = "unstable-2022-09-02";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "migen";
    rev = "639e66f4f453438e83d86dc13491b9403bbd8ec6";
    hash = "sha256-IPyhoFZLhY8d3jHB8jyvGdbey7V+X5eCzBZYSrJ18ec=";
  };

  propagatedBuildInputs = [
    colorama
  ];

  pythonImportsCheck = [ "migen" ];

  meta = with lib; {
    description = " A Python toolbox for building complex digital hardware";
    homepage = "https://m-labs.hk/migen";
    license = licenses.bsd2;
    maintainers = with maintainers; [ l-as ];
  };
}
