{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tl-expected-unstable";
  version = "2023-02-15"; # 37 commits ahead of version 1.0.0

  src = fetchFromGitHub {
    owner = "TartanLlama";
    repo = "expected";
    rev = "9d812f5e3b5bc68023f6e31d29489cdcaacef606";
    fetchSubmodules = true;
    hash = "sha256-ZokcGQgHH37nmTMLmxFcun4S1RjXuXb9NfWHet8Fbc4=";
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
