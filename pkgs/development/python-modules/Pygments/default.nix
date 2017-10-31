{ lib
, buildPythonPackage
, fetchPypi
, docutils
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k78qdvir1yb1c634nkv6rbga8wv4289xarghmsbbvzhvr311bnv";
  };

  propagatedBuildInputs = [ docutils ];

  # Circular dependency with sphinx
  doCheck = false;

  meta = {
    homepage = http://pygments.org/;
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nckx garbas ];
  };
}