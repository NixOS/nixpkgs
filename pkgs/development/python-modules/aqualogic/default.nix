{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aqualogic";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "swilson";
    repo = pname;
    rev = version;
    sha256 = "0101lni458y88yrw1wri3pz2cn5jlxln03pa3q2pxaybcyklb9qk";
  };

  propagatedBuildInputs = [ pyserial ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aqualogic" ];

  meta = with lib; {
    description = "Python library to interface with Hayward/Goldline AquaLogic/ProLogic pool controllers";
    homepage = "https://github.com/swilson/aqualogic";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
