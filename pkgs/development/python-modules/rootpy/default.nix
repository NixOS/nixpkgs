{ lib, fetchPypi, isPy3k, buildPythonPackage, numpy, matplotlib, root, root_numpy, tables, pytest }:

buildPythonPackage rec {
  pname = "rootpy";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zp2bh87l3f0shiqslbvfmavfdj8m80y8fsrz8rsi5pzqj7zr1bx";
  };

  disabled = isPy3k;

  propagatedBuildInputs = [ matplotlib numpy root root_numpy tables ];

  checkInputs = [ pytest ];
  checkPhase = ''
    # tests fail with /homeless-shelter
    export HOME=$PWD
    # skip problematic tests
    py.test rootpy -k "not test_stl and not test_cpp and not test_xrootd_glob_single and not test_xrootd_glob_multiple"
  '';

  meta = with lib; {
    homepage = http://www.rootpy.org;
    license = licenses.bsd3;
    description = "Pythonic interface to the ROOT framework";
    maintainers = with maintainers; [ veprbl ];
  };
}
