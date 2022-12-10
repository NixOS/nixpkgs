{ lib
, unittestCheckHook
, buildPythonPackage
, fetchPypi
, setuptools-scm
, backports_weakref
}:

buildPythonPackage rec {
  pname = "backports.tempfile";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c648c452e8770d759bdc5a5e2431209be70d25484e1be24876cf2168722c762";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ backports_weakref ];

  # requires https://pypi.org/project/backports.test.support
  doCheck = false;

  checkInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "tests" ];

  meta = {
    description = "Backport of new features in Python's tempfile module";
    license = lib.licenses.psfl;
    homepage = "https://github.com/pjdelport/backports.tempfile";
  };
}
