{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  version = "0.3.4";
  name = "loc-${version}";

  src = fetchFromGitHub {
    owner = "cgag";
    repo = "loc";
    rev = "9f3590f6299a1be3560f00de7f4f8bef61a02642";
    sha256 = "0dga8prwnnmsa616jh64wzic957ff0491xghm0bjlns35ajc8lif";
  };

  depsSha256 = "1xcfhbnz208dk7xb748v8kv28zbhyr7wqg9gsgbiw3lnvc2a3nn6";

  meta = {
    homepage = http://github.com/cgag/loc;
    description = "Count lines of code quickly";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}

