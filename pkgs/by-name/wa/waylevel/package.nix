{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "waylevel";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~shinyzenith";
    repo = "waylevel";
    rev = finalAttrs.version;
    hash = "sha256-T2gqiRcKrKsvwGNnWrxR1Ga/VX4AyllYn1H25aIKt5s=";
  };

  cargoHash = "sha256-W1xWVH8vKA6hItXRg4VxxvcJRUtURrUAlQFaZV4geY4=";

  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [ wayland ]} $out/bin/waylevel
  '';

  meta = {
    description = "Tool to print wayland toplevels and other compositor info";
    homepage = "https://git.sr.ht/~shinyzenith/waylevel";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dit7ya ];
    platforms = lib.platforms.linux;
    mainProgram = "waylevel";
  };
})
