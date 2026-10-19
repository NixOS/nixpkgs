{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yyjson";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "ibireme";
    repo = "yyjson";
    tag = finalAttrs.version;
    hash = "sha256-N/lVqkgko/4PRs596NtF/MyqAdO/I+QJvkVnCJWEE3I=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Fastest JSON library in C";
    homepage = "https://github.com/ibireme/yyjson";
    changelog = "https://github.com/ibireme/yyjson/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
})
