{ lib, buildPythonPackage, fetchFromGitHub, setuptools, chardet }:

buildPythonPackage rec {
  pname = "imbox";
  version = "0.9.6";

  # pypi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "martinrusev";
    repo = "imbox";
    rev = "73ef2267ee6f9af927c30be68009552fc2b0bdbe";
    sha256 = "sha256-4qMchhpkZK3cmrtRSd18PLaz/vaIE+jBIjfJnI11SWk=";
  };

  patches = [
    ./patches/Support-to-connect-163-mail-server.patch
    ./patches/Support-to-parse-chinese-attachment-file-name.patch
  ];

  propagatedBuildInputs = [ chardet ];

  doCheck = false;

  meta = with lib; {
    description =
      "Python library for reading IMAP mailboxes and converting email content to machine readable data";
    homepage = "https://github.com/martinrusev/imbox";
    license = licenses.mit;
    maintainers = with maintainers; [ lhh ];
  };
}
