{ lib, buildPythonPackage, fetchPypi, fetchpatch, isPy3k, pytest, mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "1.7.0";
 
  src = fetchPypi {
    inherit pname version;
    sha256 = "8ed6c9ac6b7565b226b4da2da48876c9198d76401ec8d9c5e4c69b45423e33f8";
  };

  patches = fetchpatch {
    url = "${meta.homepage}/pull/107.patch";
    sha256 = "07p7ra6lilfv04wyxc855zmfwxvnpmi9s0v6vh5bx769cj9jwxck";
  };

  propagatedBuildInputs = [ pytest ] ++ lib.optional (!isPy3k) mock;
  nativeBuildInputs = [ setuptools_scm ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Thin-wrapper around the mock package for easier use with py.test.";
    homepage    = https://github.com/pytest-dev/pytest-mock;
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
