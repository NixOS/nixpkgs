{ stdenv, buildPythonPackage, fetchPypi
, pygobject3
, gobjectIntrospection
, gtk3
}:

buildPythonPackage rec {
  version = "0.5.3";
  pname = "gbulb";
  name = "${pname}-${version}";

  propagatedBuildInputs = [pygobject3 gobjectIntrospection gtk3];
  src = fetchPypi {
    inherit pname version;
    sha256 = "19byqicjgb68s2lgadmwsj4c5nw7lgvz88xl90d8rvnl5vd2zs80";
  };

  meta = with stdenv.lib; {
    homepage = http://flask.pocoo.org/;
    license = licenses.bsd3;
  };
}
