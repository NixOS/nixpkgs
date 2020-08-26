{ stdenv, fetchPypi, buildPythonPackage, isPy27
, mock, pytestCheckHook, nose, hypothesis
}:

buildPythonPackage rec {
  pname = "dpath";
  version = "2.0.1";
  disabled = isPy27; # uses python3 imports

  src = fetchPypi {
    inherit pname version;
    sha256 = "bea06b5f4ff620a28dfc9848cf4d6b2bfeed34238edeb8ebe815c433b54eb1fa";
  };

  # use pytest as nosetests hangs
  checkInputs = [ mock nose pytestCheckHook hypothesis ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/akesterson/dpath-python";
    license = [ licenses.mit ];
    description = "A python library for accessing and searching dictionaries via /slashed/paths ala xpath";
    maintainers = [ maintainers.mmlb ];
  };
}
