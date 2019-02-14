{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, mozfile
, mozhttpd
}:

buildPythonPackage rec {
  pname = "mozprofile";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "94a0e14fcf357a90c42418edd414e837ff63bab876ccd51b9a7810d6f3c9fe2d";
  };

  propagatedBuildInputs = [ mozlog mozfile mozhttpd ]; 

  meta = {
    description = "Mozilla application profile handling library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
