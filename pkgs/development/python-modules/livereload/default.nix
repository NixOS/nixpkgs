{ lib
, buildPythonPackage
, fetchPypi
, nose
, django
, tornado
, six
}:

buildPythonPackage rec {
  pname = "livereload";
  version = "2.5.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b2yyfnpddmrwjfqsndidzchkf3l9jlgzfkwl8dplim9gq6y2ba2";
  };

  buildInputs = [ nose django ];

  propagatedBuildInputs = [ tornado six ];

  meta = {
    description = "Runs a local server that reloads as you develop";
    homepage = "https://github.com/lepture/python-livereload";
    license = lib.licenses.bsd3;
  };
}
