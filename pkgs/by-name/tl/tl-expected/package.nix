{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "tl-expected";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "TartanLlama";
    repo = "expected";
    rev = "v${version}";
    hash = "sha256-AuRU8VI5l7Th9fJ5jIc/6mPm0Vqbbt6rY8QCCNDOU50=";
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
