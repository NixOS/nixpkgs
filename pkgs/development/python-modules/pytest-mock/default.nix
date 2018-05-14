{ lib, buildPythonPackage, fetchPypi, fetchpatch, isPy3k, pytest, mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "1.8.0";
 
  src = fetchPypi {
    inherit pname version;
    sha256 = "2dd545496af6a0559432b11de79f1fd4fa4a541ae2e01892d5ba6041f85f0994";
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
