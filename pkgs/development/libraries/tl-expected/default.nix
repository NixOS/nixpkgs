{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tl-expected-unstable";
  version = "2019-11-11"; # 5 commits ahead of version 1.0.0

  src = fetchFromGitHub {
    owner = "TartanLlama";
    repo = "expected";
    rev = "1d9c5d8c0da84b8ddc54bd3d90d632eec95c1f13";
    fetchSubmodules = true;
    sha256 = "0rzfn9yyg70zwpxbmv22qy0015baymi2rdd65ixmcb31fgnap68i";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++11/14/17 std::expected with functional-style extensions";
    homepage = "https://tl.tartanllama.xyz/en/latest/api/expected.html";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
