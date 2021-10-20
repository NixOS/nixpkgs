{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "chmlib";
  version = "0.40a";

  src = fetchFromGitHub {
    owner = "jedwing";
    repo = "CHMLib";
    rev = "2bef8d063ec7d88a8de6fd9f0513ea42ac0fa21f";
    sha256 = "1hah0nw0l05npva2r35ywwd0kzyiiz4vamghm6d71h8170iva6m9";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "http://www.jedrea.com/chmlib";
    license = licenses.lgpl2;
    description = "A library for dealing with Microsoft ITSS/CHM format files";
    platforms = platforms.unix;
  };
}
