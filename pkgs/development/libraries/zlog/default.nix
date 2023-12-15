{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.2.17";
  pname = "zlog";

  src = fetchFromGitHub {
    owner = "HardySimpson";
    repo = pname;
    rev = version;
    sha256 = "sha256-ckpDMRLxObpl8N539DC5u2bPpmD7jM+KugurUfta6tg=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description= "Reliable, high-performance, thread safe, flexible, clear-model, pure C logging library";
    homepage = "https://hardysimpson.github.io/zlog/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.matthiasbeyer ];
    mainProgram = "zlog-chk-conf";
    platforms = platforms.unix;
  };
}
