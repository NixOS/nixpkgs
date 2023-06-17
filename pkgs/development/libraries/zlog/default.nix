{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.2.16";
  pname = "zlog";

  src = fetchFromGitHub {
    owner = "HardySimpson";
    repo = pname;
    rev = version;
    sha256 = "sha256-wpaMbFKSwTIFe3p65pMJ6Pf2qKp1uYZCyyinGU4AxrQ=";
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
