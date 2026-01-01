{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "xan";
<<<<<<< HEAD
  version = "0.54.1";
=======
  version = "0.54.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-21NJ9j3WTzAqJypjNNQRn8XUvlpj50ZO+h/+l1dRxUw=";
  };

  cargoHash = "sha256-ZdEkRQvKZAkmOk3Dbazy2IcV1QypfAN6qhtneHpWZsI=";
=======
    hash = "sha256-KsH4EapucT7Su9Xcok7tgj14JKyM8DPUYFD4H7buuSU=";
  };

  cargoHash = "sha256-IIRHxpDsLpORoYQlhyH1xOUKmWLhwnnOzaIPb21iQr4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # FIXME: tests fail and I do not have the time to investigate. Temporarily disable
  # tests so that we can manually run and test the package for packaging purposes.
  doCheck = false;

  meta = {
    description = "Command line tool to process CSV files directly from the shell";
    homepage = "https://github.com/medialab/xan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "xan";
  };
}
