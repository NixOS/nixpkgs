{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = "janet";
    rev = "v${version}";
    sha256 = "1590f1fxb6qfhf1vp2xhbvdn2jfrgipn5572cckk1ma7f13jnkpy";
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
