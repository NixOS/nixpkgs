{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "tl-expected";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "TartanLlama";
    repo = "expected";
    rev = "v${version}";
    hash = "sha256-+9M1++ZYaZNJGjEoI6+J8565R2wlznoDWW8MPrmCMoU=";
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
