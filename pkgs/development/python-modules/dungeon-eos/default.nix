{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "dungeon-eos";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-Z1fGtslXP8zcZmVeWjRrbcM2ZJsfbrWjpLWZ49uSCRY=";
  };

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "dungeon_eos" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/dungeon-eos";
    description = "A package that simulates PMD EoS dungeon generation";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 xfix ];
  };
}
