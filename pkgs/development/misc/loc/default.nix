{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  version = "2017-06-23";
  name = "loc-${version}";

  src = fetchFromGitHub {
    owner = "cgag";
    repo = "loc";
    rev = "bbea575f56879ef614d57a42a6b79fd45b9a8b38";
    sha256 = "0agyhi55rh248fmlsip4fi1iw4xv3433q7bcb2lpjfnjpzxxlvfn";
  };

  cargoSha256 = "0f3i8av9g19r2nhr9m8ca8s23kq294c5kqyvx155l6p76r7a9kvb";

  meta = {
    homepage = http://github.com/cgag/loc;
    description = "Count lines of code quickly";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}

