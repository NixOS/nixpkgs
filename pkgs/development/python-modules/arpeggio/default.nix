{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, pytest-runner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Arpeggio";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfe349f252f82f82d84cb886f1d5081d1a31451e6045275e9f90b65d0daa06f1";
  };

  # Shall not be needed for next release
  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  nativeBuildInputs = [ pytest-runner ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [ "test_examples" "test_issue_22" ];

  dontUseSetuptoolsCheck = true;

  meta = {
    description = "Packrat parser interpreter";
    license = lib.licenses.mit;
  };
}
