{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = "janet";
    rev = "v${version}";
    sha256 = "06iq2y7c9i4pcmmgc8x2fklqkj2i3jrvmq694djiiyd4x81kzcj5";
  };

  JANET_BUILD=''\"release\"'';
  PREFIX = placeholder "out";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Janet programming language";
    homepage = https://janet-lang.org/;
    license = stdenv.lib.licenses.mit;
    platforms = platforms.all;
    maintainers = with stdenv.lib.maintainers; [ andrewchambers ];
  };
}
