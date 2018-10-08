{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pycodestyle
, pytestcov
, python-coveralls
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "runtest";

  src = fetchPypi {
    inherit pname version;
    sha256 = "008371d7ce6d103dbe63bf04ea166c36d69f46f6c2f1768b4d08b53f566bf8a9";
  };

  propagatedBuildInputs = [ pytest pycodestyle pytestcov python-coveralls ];

  checkPhase = ''
    py.test runtest/check.py
    py.test runtest/extract.py
    py.test runtest/scissors.py
    py.test runtest/tuple_comparison.py
  '';

  # test files not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/bast/runtest;
    description = "Numerically tolerant end-to-end test library for scientific codes";
    license = licenses.mpl20;
    maintainers = [ maintainers.costrouc ];
  };
}
