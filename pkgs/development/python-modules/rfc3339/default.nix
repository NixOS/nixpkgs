{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "rfc3339";
  version = "6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l6l1bh91i2r4dwcm86hlkx8cbh1xwgsk8hb4jvr5y5fxxg3ng6m";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "rfc3339" ];

  meta = with lib; {
    description = "Format dates according to the RFC 3339";
    homepage = "https://hg.sr.ht/~henryprecheur/rfc3339";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
