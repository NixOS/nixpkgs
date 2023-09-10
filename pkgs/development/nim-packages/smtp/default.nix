{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage (final: prev: {
  pname = "smtp";
  version = "unstable-2023-03-04";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "smtp";
    rev = "8013aa199dedd04905d46acf3484a232378de518";
    hash = "sha256-7jPykp79nAY1G0CSajyn6Jw/Ad+XCulBk9HjtKMPEQ4=";
  };
  meta = final.src.meta // {
    description = "SMTP client";
    homepage = "https://github.com/nim-lang/smtp";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
