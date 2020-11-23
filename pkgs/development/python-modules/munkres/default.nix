{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "munkres";
  version = "1.1.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc44bf3c3979dada4b6b633ddeeb8ffbe8388ee9409e4d4e8310c2da1792db03";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with stdenv.lib; {
    homepage = "http://bmc.github.com/munkres/";
    description = "Munkres algorithm for the Assignment Problem";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };

}
