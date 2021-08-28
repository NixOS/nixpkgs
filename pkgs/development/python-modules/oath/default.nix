{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "oath";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xqgcqgx6aa0j21hwsdb3aqpqhviwj756bcqjjjcm1h1aij11p6m";
  };

  meta = with lib; {
    description = "Python implementation of the three main OATH specifications: HOTP, TOTP and OCRA";
    homepage = "https://github.com/bdauvergne/python-oath";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aw ];
  };
}
