{ pkgs, rustPlatform, fetchFromGitHub, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.4.1";

  src = "${fetchFromGitHub {
    owner = "lpil";
    repo = "gleam";
    rev = "v${version}";
    sha256 = "0d341aqgvnx5881wbwlb7r5l5ybfw69cq7jv25f1wac2cfhzl4xh";
  }}/gleam";

  cargoSha256 = "06dr5p5qin48d9bjai6l46xg14hvhzlwk7fykbjdv7il9z5lpc8v";

  meta = with stdenv.lib; {
    homepage = "https://gleam.run/";
    description = "A statically typed language for the Erlang VM";
    license = licenses.asl20;
    maintainers = [ maintainers.nobbz ];
  };
}
