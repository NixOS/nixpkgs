{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, mozfile
, mozhttpd
}:

buildPythonPackage rec {
  pname = "mozprofile";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95e7410ff2a65775422936749b346da8abf09fe0aafa3bb5dd1651b17da137d1";
  };

  propagatedBuildInputs = [ mozlog mozfile mozhttpd ]; 

  meta = {
    description = "Mozilla application profile handling library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
