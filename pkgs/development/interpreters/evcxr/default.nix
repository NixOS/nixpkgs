{ cargo, fetchFromGitHub, makeWrapper, pkg-config, rustPlatform, lib, stdenv
, gcc, cmake, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
<<<<<<< HEAD
  version = "0.15.1";
=======
  version = "0.14.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = "evcxr";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-IQM/uKDxt18rVOd6MOKhQZC26vjxVe+3Yn479ITFDFs=";
  };

  cargoHash = "sha256-6kyxAHxphZjwfHo7OHrATSKFzrpXIRHVTjynDawlWew=";
=======
    sha256 = "sha256-gREAtCh4jerqxhwNslXIXRMLkoj0RlhbIwQXbb8LVws=";
  };

  cargoSha256 = "sha256-xuxWOVSUJVQvSDA5xhFBjdO/ODLA4fzEnzG9p0DRF2Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";

  nativeBuildInputs = [ pkg-config makeWrapper cmake ];
  buildInputs = lib.optionals stdenv.isDarwin
    [ libiconv CoreServices Security ];

<<<<<<< HEAD
  checkFlags = [
    # test broken with rust 1.69:
    # * https://github.com/evcxr/evcxr/issues/294
    # * https://github.com/NixOS/nixpkgs/issues/229524
=======
  # test broken with rust 1.69:
  # * https://github.com/evcxr/evcxr/issues/294
  # * https://github.com/NixOS/nixpkgs/issues/229524
  checkFlags = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--skip=check_for_errors"
  ];

  postInstall = let
    wrap = exe: ''
      wrapProgram $out/bin/${exe} \
        --prefix PATH : ${lib.makeBinPath [ cargo gcc ]} \
        --set-default RUST_SRC_PATH "$RUST_SRC_PATH"
    '';
  in ''
    ${wrap "evcxr"}
    ${wrap "evcxr_jupyter"}
    rm $out/bin/testing_runtime
  '';

  meta = with lib; {
    description = "An evaluation context for Rust";
    homepage = "https://github.com/google/evcxr";
    license = licenses.asl20;
    maintainers = with maintainers; [ protoben ma27 ];
  };
}
