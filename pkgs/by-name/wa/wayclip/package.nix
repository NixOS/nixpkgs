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
  version = "0.5";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~noocsharp";
    repo = "wayclip";
    rev = finalAttrs.version;
    hash = "sha256-Uej5ggtlPeDid1yKSfZt5FlCen1GLea6EWa4lL+BPRM=";
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
