{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ncurses,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
<<<<<<< HEAD
  version = "0.9.2";
=======
  version = "0.9.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = "wiki-tui";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-hUAe2mzz/4xdpyPE2rbTq5WKk0bNa4dSFocFiCXyO4Q=";
=======
    hash = "sha256-eTDxRrTP9vX7F1lmDCuF6g1pfaZChqB8Pv1kfrd7I9w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    openssl
  ];

<<<<<<< HEAD
  cargoHash = "sha256-0M3vHj/dzHcI2FJLramTsFMw4m/WGp9vX9Tq52dSW1o=";
=======
  cargoHash = "sha256-Pe6mNbn4GFjhpFZeWMlaRt7Bj5BLiIy789hXWkII2ps=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    changelog = "https://github.com/Builditluc/wiki-tui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
<<<<<<< HEAD
=======
      lom
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      builditluc
      matthiasbeyer
    ];
    mainProgram = "wiki-tui";
  };
}
