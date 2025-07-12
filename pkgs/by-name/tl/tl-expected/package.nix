{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "tl-expected";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "TartanLlama";
    repo = "expected";
    rev = "v${version}";
    hash = "sha256-puVjJJK0ImCfQBcwjkustbYKjvgQVg0by/sc2rNaRQE=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++11/14/17 std::expected with functional-style extensions";
    homepage = "https://tl.tartanllama.xyz/en/latest/api/expected.html";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
