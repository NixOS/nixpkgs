{ lib
, buildPythonPackage
, fetchFromGitHub
, gettext
, mock
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "bagit";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "LibraryOfCongress";
    repo = "bagit-python";
    rev = "v${version}";
    hash = "sha256-t01P7MPWgOrktuW2zF0TIzt6u/jkLmrpD2OnqawhJaI=";
  };

  nativeBuildInputs = [ gettext setuptools-scm ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];
  pytestFlagsArray = [ "test.py" ];
  pythonImportsCheck = [ "bagit" ];

  meta = with lib; {
    description = "Python library and command line utility for working with BagIt style packages";
    homepage = "https://libraryofcongress.github.io/bagit-python/";
    license = with licenses; [ publicDomain ];
    maintainers = with maintainers; [ veprbl ];
  };
}
