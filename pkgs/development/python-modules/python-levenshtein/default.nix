{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-Levenshtein";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0489zzjlfgzpc7vggs7s7db13pld2nlnw7iwgdz1f386i0x2fkjm";
  };

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    description = "Functions for fast computation of Levenshtein distance and string similarity";
    homepage    = "https://github.com/ztane/python-Levenshtein";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ aske ];
  };

}
