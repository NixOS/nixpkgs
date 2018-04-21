{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mozlog
, mozfile
, mozhttpd
}:

buildPythonPackage rec {
  pname = "mozprofile";
  version = "0.29";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "92af4b9f527a18997dccb60e846e1844b2428668dadf3ccb1a8cd30c706b25c1";
  };

  propagatedBuildInputs = [ mozlog mozfile mozhttpd ]; 

  meta = {
    description = "Mozilla application profile handling library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
