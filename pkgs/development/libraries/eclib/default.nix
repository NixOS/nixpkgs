{stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext, autoreconfHook
, pari, ntl, gmp}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "eclib";
  version = "20160720";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchFromGitHub {
    owner = "JohnCremona";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0qrcd5c8cqhw9f14my6k6013w8li5vdigrjvchkr19n2l8g75j0h";
  };
  buildInputs = [pari ntl gmp];
  nativeBuildInputs = [autoconf automake libtool gettext autoreconfHook];
  meta = {
    inherit version;
    description = ''Elliptic curve tools'';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
