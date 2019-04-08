{ stdenv
, buildPythonPackage
, isPy3k
, fetchdarcs
, greenlet
}:

buildPythonPackage rec {
  pname = "python-eventlib";
  version = "0.2.2";
  # Judging from SyntaxError
  disabled = isPy3k;

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/${pname}";
    rev = "release-${version}";
    sha256 = "1zxhpq8i4jwsk7wmfncqfm211hqikj3hp38cfv509924bi76wak8";
  };

  propagatedBuildInputs = [ greenlet ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Eventlib bindings for python";
    homepage    = "http://ag-projects.com/";
    license     = licenses.lgpl2;
  };

}
