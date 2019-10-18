{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, pytestrunner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Arpeggio";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "948ce06163a48a72c97f4fe79ad3d1c1330b6fec4f22ece182fb60ef60bd022b";
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
