{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation {
  name = "pony-stable-unstable-2017-01-03";

  src = fetchFromGitHub {
    owner = "jemc";
    repo = "pony-stable";
    rev = "0054b429a54818d187100ed40f5525ec7931b31b";
    sha256 = "0libx8byzwqjjgxxyiiahiprzzp845xgbk09sx9bzban5cd5j0g5";
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
