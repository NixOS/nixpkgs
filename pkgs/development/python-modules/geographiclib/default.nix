{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "geographiclib";
  version = "1.49";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cv514gcafbxpa3p6prz5aqxxxxc7l85v1r83fw5f2p8zi4acpb3";
  };

  meta = {
    description = "The geodesic routines from GeographicLib";
    homepage = "https://geographiclib.sourceforge.io/1.49/python";
    license = with lib.licenses; [ mit ];
  };
}
