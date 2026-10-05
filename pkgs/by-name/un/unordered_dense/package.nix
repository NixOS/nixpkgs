{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unordered_dense";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "martinus";
    repo = "unordered_dense";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n9aFanLHhSsZ/K3l68FJy/9vgaJBSRgb/jaxsHNN7Mw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Fast & densely stored hashmap and hashset based on robin-hood backward shift deletion";
    homepage = "https://github.com/martinus/unordered_dense";
    changelog = "https://github.com/martinus/unordered_dense/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
