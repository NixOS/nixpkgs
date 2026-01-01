{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
<<<<<<< HEAD
  version = "0.15.0";
=======
  version = "0.14.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = "tickrs";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JqX+PEob99O1VRYbw7RH6KGA1CXYyepkM9Uc5jkWlrM=";
  };

  cargoHash = "sha256-CbLRq/jsCqZ3Uz1WeEL2ARUXlmlDIrmZNTiyZRo8QLw=";
=======
    hash = "sha256-0jpElAj4TDC52BEjfnGHYiro6MT6Jzcb0evvmroxLn8=";
  };

  cargoHash = "sha256-Ii9Fn6J5qpqigH7oWIfOX+JKkzQ2BNpeNg1sF+ONCrM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
<<<<<<< HEAD
    changelog = "https://github.com/tarkah/tickrs/blob/${src.tag}/CHANGELOG.md";
=======
    changelog = "https://github.com/tarkah/tickrs/blob/v${version}/CHANGELOG.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "tickrs";
  };
}
