{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = "janet";
    rev = "v${version}";
    sha256 = "1w6d5a4akd868x89bgyvw3cnadfva7gnyvhmxx5ixxd580n5ba6v";
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
