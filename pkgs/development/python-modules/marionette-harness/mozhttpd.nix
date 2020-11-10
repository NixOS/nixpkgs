{ lib
, buildPythonPackage
, fetchPypi
, moznetwork
}:

buildPythonPackage rec {
  pname = "mozhttpd";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e2a9b4d6c007a1a9fb729d6e95b5404d138914727747e10155426492dced975";
  };

  propagatedBuildInputs = [ moznetwork ];

  meta = {
    description = "Webserver for Mozilla testing";
    homepage = "https://wiki.mozilla.org/Auto-tools/Projects/Mozbase";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
