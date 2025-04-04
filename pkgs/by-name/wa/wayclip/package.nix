{
  lib,
  stdenv,
  fetchFromSourcehut,
  nix-update-script,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayclip";
  version = "a62ac18e5e56085bd416fbe5fbe22b3560291e7b";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~noocsharp";
    repo = "wayclip";
    rev = finalAttrs.version;
    hash = "sha256-/xii/FF8JPv6KbMMxzww9AYqYJrpKYowsxQ5Bz7m+/M=";
  };

  strictDeps = true;

  nativeBuildInputs = [ wayland-scanner ];

  buildInputs = [ wayland ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland clipboard utility";
    homepage = "https://sr.ht/~noocsharp/wayclip/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "waycopy";
    inherit (wayland.meta) platforms;
  };
})
