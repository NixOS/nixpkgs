{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "PyRSS2Gen";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rvf5jw9hknqz02rp1vg8abgb1lpa0bc65l7ylmlillqx7bswq3r";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://www.dalkescientific.om/Python/PyRSS2Gen.html;
    description = "Library for generating RSS 2.0 feeds";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
