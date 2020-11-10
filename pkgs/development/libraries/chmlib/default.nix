{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "chmlib-0.40a";

  src = fetchFromGitHub {
    owner = "jedwing";
    repo = "CHMLib";
    rev = "2bef8d063ec7d88a8de6fd9f0513ea42ac0fa21f";
    sha256 = "1hah0nw0l05npva2r35ywwd0kzyiiz4vamghm6d71h8170iva6m9";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "http://www.jedrea.com/chmlib";
    license = stdenv.lib.licenses.lgpl2;
    description = "A library for dealing with Microsoft ITSS/CHM format files";
    platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux"];
  };
}
