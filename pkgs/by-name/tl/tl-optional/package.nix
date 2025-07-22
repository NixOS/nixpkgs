{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tl-optional";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "TartanLlama";
    repo = "optional";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WPTXTQmzJjAIJI1zM6svZZTO8gP/jt5xDHHRCCu9cmI=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = " C++11/14/17 std::optional with functional-style extensions and reference support";
    homepage = "https://tl.tartanllama.xyz/en/latest/api/optional.html";
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
