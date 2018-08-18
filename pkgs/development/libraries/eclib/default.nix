{ stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
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
  version = "20180710"; # upgrade might break the sage interface
  # sage tests to run:
  # src/sage/interfaces/mwrank.py
  # src/sage/libs/eclib
  # ping @timokau for more info
  src = fetchFromGitHub {
    owner = "JohnCremona";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1kmwpw971sipb4499c9b35q5pz6sms5qndqrvq7396d8hhwjg1i2";
  };
  patches = [
    # One of the headers doesn't get installed.
    # See https://github.com/NixOS/nixpkgs/pull/43476.
    (fetchpatch {
      url = "https://github.com/JohnCremona/eclib/pull/42/commits/c9b96429815e31a6e3372c106e31eef2a96431f9.patch";
      sha256 = "0cw26h94m66rbh8jjsfnb1bvc6z7ybh8zcp8xl5nhxjxiawhcl73";
    })
  ];
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
  meta = with stdenv.lib; {
    inherit version;
    description = ''Elliptic curve tools'';
    homepage = https://github.com/JohnCremona/eclib;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin timokau ];
    platforms = platforms.all;
  };
}
