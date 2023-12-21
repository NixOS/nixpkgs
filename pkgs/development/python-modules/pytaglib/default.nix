{ lib
, buildPythonPackage
, fetchFromGitHub
, taglib
, cython
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytaglib";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "supermihi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-CEpyRxC9d7EuxupMQaX7WUCZ7lhyE6LhQY7Koe0NJ1A=";
  };

  buildInputs = [
    cython
    taglib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "taglib"
  ];

  meta = with lib; {
    description = "Python bindings for the Taglib audio metadata library";
    homepage = "https://github.com/supermihi/pytaglib";
    changelog = "https://github.com/supermihi/pytaglib/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mrkkrp ];
  };
}
