{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "PyPlatec";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kqx33flcrrlipccmqs78d14pj5749bp85b6k5fgaq2c7yzz02jg";
  };

  meta = with stdenv.lib; {
    description = "Library to simulate plate tectonics with Python bindings";
    homepage    = https://github.com/Mindwerks/plate-tectonics;
    license     = licenses.lgpl3;
  };

}
