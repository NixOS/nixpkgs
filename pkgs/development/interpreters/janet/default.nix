{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = "janet";
    rev = "v${version}";
    sha256 = "00lrj21k85sqyn4hv2rc5sny9vxghafjxyvs0dq4zp68461s3l7c";
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
