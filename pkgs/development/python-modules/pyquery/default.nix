{ stdenv
, buildPythonPackage
, fetchPypi
, cssselect
, lxml
, webob
}:

buildPythonPackage rec {
  pname = "pyquery";
  version = "1.2.9";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "00p6f1dfma65192hc72dxd506491lsq3g5wgxqafi1xpg2w1xia6";
  };

  propagatedBuildInputs = [ cssselect lxml webob ];

  # circular dependency on webtest
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/gawel/pyquery;
    description = "A jquery-like library for python";
    license = licenses.bsd0;
  };

}
