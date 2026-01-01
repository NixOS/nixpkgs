{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeekstd";
<<<<<<< HEAD
  version = "0.4.3";
=======
  version = "0.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rorosen";
    repo = "zeekstd";
    tag = "v${finalAttrs.version}-cli";
<<<<<<< HEAD
    hash = "sha256-E8xOcc3gDCRSZUrnrAPOJGnx0YSK/1FxZZOgusESpeE=";
  };

  cargoHash = "sha256-0wqRDhopbSfILABEpjuTLfOuwIH+5jzTVl9av7+7098=";
=======
    hash = "sha256-aht+QUprnSdBxJajBPgzqWzzOpkyrtzvJ98nqYKDCdc=";
  };

  cargoHash = "sha256-GEWCR4EaNQkB9mYxcWjlqSt75ko68RIU/10M4+zB+to=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "CLI tool that works with the zstd seekable format";
    homepage = "https://github.com/rorosen/zeekstd";
    changelog = "https://github.com/rorosen/zeekstd/releases/tag/v${finalAttrs.version}-cli";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.rorosen ];
    mainProgram = "zeekstd";
  };
})
