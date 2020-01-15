{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  version = "0.4.1";
  pname = "loc";

  src = fetchFromGitHub {
    owner = "cgag";
    repo = "loc";
    rev = "v${version}";
    sha256 = "0086asrx48qlmc484pjz5r5znli85q6qgpfbd81gjlzylj7f57gg";
  };

  cargoSha256 = "06iqzpg5jz1xd2amajvlf7yaz9kr3q2ipbhx71whvv9mwplmxmbi";

  meta = with stdenv.lib; {
    homepage = https://github.com/cgag/loc;
    description = "Count lines of code quickly";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = platforms.unix;
  };
}

