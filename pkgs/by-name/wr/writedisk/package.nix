{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "writedisk";
  version = "1.3.0";

  src = fetchCrate {
    inherit version;
    pname = "writedisk";
    hash = "sha256-MZFnNb8rJMu/nlH8rfnD//bhqPSkhyXucbTrwsRM9OY=";
  };

  cargoHash = "sha256-DGroBBozAViibbIYbtqH2SxIGLqdtyJ9XKyz7O1L05g=";

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Small utility for writing a disk image to a USB drive";
    homepage = "https://github.com/nicholasbishop/writedisk";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ devhell ];
  };
}
