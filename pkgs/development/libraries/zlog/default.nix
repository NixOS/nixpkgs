{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.2.15";
  pname = "zlog";

  src = fetchFromGitHub {
    owner = "HardySimpson";
    repo = pname;
    rev = version;
    sha256 = "10hzifgpml7jm43y6v8c8q0cr9ziyx9qxznafxyw6glhnlqnb7pb";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description= "Reliable, high-performance, thread safe, flexible, clear-model, pure C logging library";
    homepage = "https://hardysimpson.github.io/zlog/";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = [ maintainers.matthiasbeyer ];
  };

}
