{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation {
  name = "pony-stable-unstable-2017-03-30";

  src = fetchFromGitHub {
    owner = "jemc";
    repo = "pony-stable";
    rev = "39890c7f11f79009630de6b551bd076868f7f5a2";
    sha256 = "1w15dg4l03zzncpllwww8jhsj7z1wgvhf89n7agr9f1w9m2zpskc";
  };

  buildInputs = [ ponyc ];

  installPhase = ''
    make prefix=$out install
  '';

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = http://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.dipinhora ];
    platforms = stdenv.lib.platforms.unix;
  };
}
