{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "groupie";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "mawildoer";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-vLtm3P3qhJspokygYUu6e/BmtgqjMIO6wvP7ewu4ya8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonImportsCheck = [ "groupie" ];

  meta = {
    description = "Exception group utilities for exceptional code";
    homepage = "https://github.com/mawildoer/groupie";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seedart ];
  };
}
