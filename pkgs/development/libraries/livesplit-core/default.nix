{ lib
, fetchFromGitHub
, rustPlatform
, dynamicLib ? true
, generateBindings ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "livesplit-core";
  version = "unstable-2021-08-23";

  src = fetchFromGitHub {
    owner = "livesplit";
    repo = pname;
    rev = "6fb02347f0ec4db8fb4bd8e284f8a8bc71e15686";
    sha256 = "0279hmlcdpbd5g6x02vp8gq8zj8j37kzw6d5k892rp5fr4z5xkga";
  };

  # Upstream does not provide a lockfile for cargo dependency versions, so we use our own.
  cargoPatches = [ ./Cargo.lock ];
  cargoSha256 = "1g3x9aaq108lnk1yvyhqkwyzwfxias12z2bkbi8s8qyk3z3vgg22";

  cargoBuildFlags = [ "-p" (if dynamicLib then "cdylib" else "staticlib") ];

  postBuild = lib.optionalString generateBindings ''
    echo "Generating bindings..."

    cd capi/bind_gen
    cargo run --frozen # This compiles the bindings to "capi/bindings"
    cd ../..
  '';

  preInstall = lib.optionalString generateBindings ''
    mkdir -p $out/lib
    cp -r capi/bindings $out/lib
  '';

  meta = with lib; {
    description = "A library that provides a lot of functionality for creating a speedrun timer";
    homepage = "https://github.com/LiveSplit/livesplit-core";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.ivar ];
  };
}
