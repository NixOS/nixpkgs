{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zuo";
  version = "unstable-2022-11-15";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    rev = "7492a8aa3721bfad7d158497313b913537a8b12d";
    hash = "sha256-9tMYaKjBTGm9NjcytpUS9mgBlE9L1U2VECsqfU706u4=";
  };

  doCheck = true;

  meta = with lib; {
    description = "A Tiny Racket for Scripting";
    homepage = "https://github.com/racket/zuo";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
