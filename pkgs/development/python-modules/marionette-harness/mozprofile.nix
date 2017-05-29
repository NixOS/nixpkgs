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
  version = "0.28";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15xsdhrpbg7hlr6nvb3k3ci33h786hrv12az8j2k7aa9gzjcf8nh";
  };

  propagatedBuildInputs = [ mozlog mozfile mozhttpd ]; 

  meta = {
    description = "Mozilla application profile handling library";
    homepage = "https://wiki.mozilla.org/Auto-tools/Projects/Mozbase";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
