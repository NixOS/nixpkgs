{ stdenv
, buildPythonPackage
, fetchurl
, logilab_common
}:

buildPythonPackage rec {
  pname = "logilab-astng";
  version = "0.24.3";

  src = fetchurl {
    url = "http://download.logilab.org/pub/astng/${pname}-${version}.tar.gz";
    sha256 = "0np4wpxyha7013vkkrdy54dvnil67gzi871lg60z8lap0l5h67wn";
  };

  propagatedBuildInputs = [ logilab_common ];

  meta = with stdenv.lib; {
    homepage = https://www.logilab.org/project/logilab-astng;
    description = "Python Abstract Syntax Tree New Generation";
    license = licenses.lgpl2;
  };

}
