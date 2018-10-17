{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zi94m99ziwwd6kkip3w2xpnl05r2cfv9iq68inz7np81c3g8vag";
  };

  meta = with stdenv.lib; {
    description = "A simple Python module for parsing human names into their individual components";
    homepage = https://github.com/derek73/python-nameparser;
    license = licenses.lgpl21Plus;
  };

}
