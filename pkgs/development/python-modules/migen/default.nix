{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colorama,
}:

buildPythonPackage {
  pname = "migen";
  version = "unstable-2022-09-02";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "migen";
    rev = "639e66f4f453438e83d86dc13491b9403bbd8ec6";
    hash = "sha256-IPyhoFZLhY8d3jHB8jyvGdbey7V+X5eCzBZYSrJ18ec=";
  };

  propagatedBuildInputs = [ colorama ];

  pythonImportsCheck = [ "migen" ];

  meta = {
    description = " A Python toolbox for building complex digital hardware";
    homepage = "https://m-labs.hk/migen";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ l-as ];
  };
}
