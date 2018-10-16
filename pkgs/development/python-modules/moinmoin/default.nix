{ lib, buildPythonPackage, fetchurl, fetchpatch, isPy3k
, pytest, werkzeug, pygments
}:

buildPythonPackage rec {
  pname = "moinmoin";
  version = "1.9.10";

  # Not yet supported, see http://moinmo.in/Python3
  disabled = isPy3k;

  src = fetchurl {
    url = "http://static.moinmo.in/files/moin-${version}.tar.gz";
    sha256 = "0g05lnl1s8v61phi3z1g3b6lfj4g98grj9kw8nyjl246x0c489ja";
  };

  patches = [
    ./fix_tests.patch
  ];

  checkInputs = [ pytest werkzeug pygments ];

  meta = with lib; {
    description = "Advanced, easy to use and extensible WikiEngine";

    homepage = "https://moinmo.in/";

    license = licenses.gpl2Plus;
  };
}
