{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "imaplib2";
  version = "3.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "imaplib2";
    rev = "v${version}";
    sha256 = "14asi3xnvf4bb394k5j8c3by6svvmrr75pawzy6kaax5jx0h793m";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "imaplib2" ];

  meta = {
    description = "Threaded Python IMAP4 client";
    homepage = "https://github.com/jazzband/imaplib2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
