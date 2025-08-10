{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  wayland,
}:
rustPlatform.buildRustPackage rec {
  pname = "waylevel";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~shinyzenith";
    repo = "waylevel";
    rev = version;
    hash = "sha256-T2gqiRcKrKsvwGNnWrxR1Ga/VX4AyllYn1H25aIKt5s=";
  };

  cargoHash = "sha256-W1xWVH8vKA6hItXRg4VxxvcJRUtURrUAlQFaZV4geY4=";

  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [ wayland ]} $out/bin/waylevel
  '';

  meta = with lib; {
    description = "Tool to print wayland toplevels and other compositor info";
    homepage = "https://git.sr.ht/~shinyzenith/waylevel";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
    mainProgram = "waylevel";
  };
}
