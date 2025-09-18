{
  lib,
  stdenv,
  fetchFromSourcehut,
  gitUpdater,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayclip";
  version = "0.4.2";

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
    updateScript = gitUpdater { };
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
