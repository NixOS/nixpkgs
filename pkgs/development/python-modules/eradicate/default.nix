{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "eradicate";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qsc4SrJbG/IcTAEt6bS/g5iUWhTJjJEVRbLqUKtVgBQ=";
  };

  meta = with lib; {
    description = "Library to remove commented-out code from Python files";
    homepage = "https://github.com/myint/eradicate";
    changelog = "https://github.com/wemake-services/eradicate/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mmlb ];
  };
}
