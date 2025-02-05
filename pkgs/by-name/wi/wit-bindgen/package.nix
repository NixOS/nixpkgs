{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "wit-bindgen";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wit-bindgen";
    rev = "v${version}";
    hash = "sha256-2hTSFz6S+sncqXY8FRzvy5iUt3HeLi3q3Ze1u+cZV1Y=";
  };

<<<<<<< HEAD
  useFetchCargoVendor = true;
  cargoHash = "sha256-g0fo4twFHS8c98Y1ZFWlpsame1S42r53k6um3BnQuT4=";
||||||| 7813ce378424
  cargoHash = "sha256-AoJWsTyNbgWxFzcLwHt3tmyfn6zfU242hV5KJ+njL+Q=";
=======
  cargoHash = "sha256-D7W9UB0NmGMvRiI58vaP95R+CRRSWqcwj/MJNwlyGxE=";
>>>>>>> origin/master

  # Some tests fail because they need network access to install the `wasm32-unknown-unknown` target.
  # However, GitHub Actions ensures a proper build.
  # See also:
  #   https://github.com/bytecodealliance/wit-bindgen/actions
  #   https://github.com/bytecodealliance/wit-bindgen/blob/main/.github/workflows/main.yml
  doCheck = false;

  meta = with lib; {
    description = "Language binding generator for WebAssembly interface types";
    homepage = "https://github.com/bytecodealliance/wit-bindgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "wit-bindgen";
  };
}
