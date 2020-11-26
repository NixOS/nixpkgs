{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, pytestrunner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Arpeggio";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "920d12cc762edb2eb56daae64a14c93e43dc181b481c88fc79314c0df6ee639e";
  };

  # Shall not be needed for next release
  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [ "test_examples" "test_issue_22" ];

  dontUseSetuptoolsCheck = true;

  meta = {
    description = "Packrat parser interpreter";
    license = lib.licenses.mit;
  };
}
