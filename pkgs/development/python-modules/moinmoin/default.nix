{ lib, buildPythonPackage, fetchurl, isPy3k
, pytest, werkzeug, pygments
}:

buildPythonPackage rec {
  pname = "moinmoin";
  version = "1.9.11";

  # SyntaxError in setup.py
  disabled = isPy3k;

  src = fetchurl {
    url = "http://static.moinmo.in/files/moin-${version}.tar.gz";
    sha256 = "sha256-Ar4x1V851P4MYlPfi0ngG3bQlWNMvRtW0YX2bh4MPPU=";
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
