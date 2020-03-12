{ stdenv
, buildPythonPackage
, isPy3k
, fetchdarcs
, greenlet
}:

buildPythonPackage rec {
  pname = "python-eventlib";
  version = "0.2.4";
  # Judging from SyntaxError
  disabled = isPy3k;

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/${pname}";
    rev = "release-${version}";
    sha256 = "1w1axsm6w9bl2smzxmyk4in1lsm8gk8ma6y183m83cpj66aqxg4z";
  };

  propagatedBuildInputs = [ greenlet ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Eventlib bindings for python";
    homepage    = "https://ag-projects.com/";
    license     = licenses.lgpl2;
  };

}
