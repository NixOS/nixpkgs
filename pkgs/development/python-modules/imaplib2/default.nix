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
    hash = "sha256-daQDQZelKzWN/1zdcnKue2vj12BIlknSWIu4bfuIWpE=";
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
