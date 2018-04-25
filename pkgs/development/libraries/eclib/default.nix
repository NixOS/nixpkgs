{ stdenv
, fetchFromGitHub
, autoreconfHook
, libtool
, gettext
, pari
, ntl
, gmp
# "FLINT is optional and only used for one part of sparse matrix reduction,
# which is used in the modular symbol code but not mwrank or other elliptic
# curve programs." -- https://github.com/JohnCremona/eclib/blob/master/README
, withFlint ? false, flint ? null
}:

assert withFlint -> flint != null;

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "eclib";
  version = "20171002";
  src = fetchFromGitHub {
    owner = "JohnCremona";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "092an90405q9da0k0z5jfp5rng9jl0mqbvsbv4fx6jc9ykfcahsj";
  };
  buildInputs = [
    pari
    ntl
    gmp
  ] ++ stdenv.lib.optionals withFlint [
    flint
  ];
  nativeBuildInputs = [
    autoreconfHook
  ];
  doCheck = true;
  meta = {
    inherit version;
    description = ''Elliptic curve tools'';
    homepage = https://github.com/JohnCremona/eclib;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
