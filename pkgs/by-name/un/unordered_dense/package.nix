{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unordered_dense";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "martinus";
    repo = "unordered_dense";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JdPlyShWnAcdgixDHRaroFg7YWdPtD4Nl1PmpcQ1SAk=";
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
