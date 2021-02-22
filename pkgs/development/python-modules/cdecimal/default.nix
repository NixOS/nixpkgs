{ lib, buildPythonPackage, fetchurl, isPy3k }:

buildPythonPackage rec {
  pname = "cdecimal";
  version = "2.3";

  disabled = isPy3k;

  src = fetchurl {
    url="http://www.bytereef.org/software/mpdecimal/releases/${pname}-${version}.tar.gz";
    sha256 = "d737cbe43ed1f6ad9874fb86c3db1e9bbe20c0c750868fde5be3f379ade83d8b";
  };

  # Upstream tests are not included s. a. http://www.bytereef.org/mpdecimal/testing.html
  doCheck = false;

  meta = with lib; {
    description = "Fast drop-in replacement for decimal.py";
    homepage    = "http://www.bytereef.org/mpdecimal/";
    license     = licenses.bsd2;
    maintainers = [ maintainers.udono ];
  };
}
