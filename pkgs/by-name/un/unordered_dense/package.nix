{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unordered_dense";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "martinus";
    repo = "unordered_dense";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dnPbVlQOcwD7p5uuN56vEin+/+d83xh6szW+Uth/HHk=";
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
