{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "dungeon-eos";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "0hxygjk9i4qlwsxnxr52cxhqy3i62pc373z1x5sh2pas5ag59bvl";
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
