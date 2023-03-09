{ lib, stdenv, fetchFromGitHub, fetchurl, rust, rustPlatform, cargo-c, python3 }:

let
  rustTargetPlatformSpec = rust.toRustTargetSpec stdenv.hostPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "libimagequant";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = pname;
    rev = version;
    hash = "sha256-W9Q81AbFhWUe6c3csAnm8L5wLqURizrjwqcurWhPISI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoHash = "sha256-0HOmItooNsGq6iTIb9M5IPXMwYh2nQ03qfjomkg0d00=";

  auditable = true; # TODO: remove when this is the default

  nativeBuildInputs = [ cargo-c ];

  postBuild = ''
    pushd imagequant-sys
    cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${rustTargetPlatformSpec}
    popd
  '';

  postInstall = ''
    pushd imagequant-sys
    cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${rustTargetPlatformSpec}
    popd
  '';

  passthru.tests = {
    inherit (python3.pkgs) pillow;
  };

  meta = with lib; {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma9e marsam ];
  };
}
