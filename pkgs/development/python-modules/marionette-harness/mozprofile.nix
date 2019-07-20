{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, mozfile
, mozhttpd
}:

buildPythonPackage rec {
  pname = "mozprofile";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa7fe7248719a224dd63cdc0498c9971d07cfc62fee7a69f51d593316b6bc1d8";
  };

  propagatedBuildInputs = [ mozlog mozfile mozhttpd ]; 

  meta = {
    description = "Mozilla application profile handling library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
