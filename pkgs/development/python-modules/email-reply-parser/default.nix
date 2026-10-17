{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "email-reply-parser";
  version = "0.5.12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zapier";
    repo = "email-reply-parser";
    rev = "v${version}";
    hash = "sha256-UFyqYVvZMQ46Ph9h6Z21t1sDS4QTmjeJMFZjBiWOJNs=";
  };

  pythonImportsCheck = [ "email_reply_parser" ];

  meta = with lib; {
    description = "Library to parse the last reply in emails";
    homepage = "https://github.com/zapier/email-reply-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

