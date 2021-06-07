{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aqualogic";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "swilson";
    repo = pname;
    rev = version;
    sha256 = "sha256-dAC/0OjvrC8J/5pu5vcOKV/WqgkAlz0LuFl0up6FQRM=";
  };

  patches = [
    (fetchpatch {
      name = "allow-iobase-objects.patch";
      url = "https://github.com/swilson/aqualogic/commit/185fe25a86c82c497a55c78914b55ed39f5ca339.patch";
      sha256 = "072jrrsqv86bn3skibjc57111jlpm8pq2503997fl3h4v6ziwdxg";
    })
  ];

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
