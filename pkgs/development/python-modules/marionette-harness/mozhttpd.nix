{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, moznetwork
}:

buildPythonPackage rec {
  pname = "mozhttpd";
  version = "0.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10y1cr933ajx9ni701ayb7r361pak9wrzr7pdpyx81kkbjddq7qa";
  };

  propagatedBuildInputs = [ moznetwork ]; 

  meta = {
    description = "Webserver for Mozilla testing";
    homepage = "https://wiki.mozilla.org/Auto-tools/Projects/Mozbase";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
