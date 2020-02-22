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

  cargoSha256 = "1fgv1kxiif48q9mm60ygn88r5nkxfyiacmvbgwp0jxiacv8r7779";

  meta = with stdenv.lib; {
    homepage = https://github.com/cgag/loc;
    description = "Count lines of code quickly";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = platforms.unix;
  };
}

