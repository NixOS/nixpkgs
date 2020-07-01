{ lib, buildPythonPackage, fetchurl, isPy3k
, pytest, werkzeug, pygments
}:

buildPythonPackage rec {
  pname = "moinmoin";
  version = "1.9.10";

  # SyntaxError in setup.py
  disabled = isPy3k;

  src = fetchurl {
    url = "http://static.moinmo.in/files/moin-${version}.tar.gz";
    sha256 = "0g05lnl1s8v61phi3z1g3b6lfj4g98grj9kw8nyjl246x0c489ja";
  };

  patches = [
    # Recommended to install on their download page.
    ./fix_tests.patch
  ];

  prePatch = ''
    sed -i "s/\xfc/ü/" setup.cfg
  '';

  checkInputs = [ pytest werkzeug pygments ];

  meta = with lib; {
    description = "Advanced, easy to use and extensible WikiEngine";

    homepage = "https://moinmo.in/";

    license = licenses.gpl2Plus;
  };
}
