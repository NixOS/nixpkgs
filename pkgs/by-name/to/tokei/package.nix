{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  darwin,
  zlib,
  testers,
  tokei,
}:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "13.0.0-alpha.5";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-o5MIwDw8/y9k+FSmSVjFHAeJ/g2F3chPrF7HhkEzCIw=";
  };

  cargoHash = "sha256-rEAvn8ecTrFtU2bo0vpt5BELOriqhzB8AtFmhe5gr74=";

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.Security
  ];

  checkInputs = lib.optionals stdenv.isDarwin [ zlib ];

  # enable all output formats
  buildFeatures = [ "all" ];

  passthru.tests = {
    version = testers.testVersion { package = tokei; };
  };

  meta = with lib; {
    description = "Program that allows you to count your code, quickly";
    longDescription = ''
      Tokei is a program that displays statistics about your code. Tokei will show number of files, total lines within those files and code, comments, and blanks grouped by language.
    '';
    homepage = "https://github.com/XAMPPRocky/tokei";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ gebner sigmanificient ];
    mainProgram = "tokei";
  };
}
