{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "terrascope";
  version = "1.0.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "a-shygun";
    repo = "Terrascope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-emrWNgaGbsAbm3ZMTMnbgcNlFzUU/a+4O7jMIRRx/8k=";
  };

  pyproject = true;
  build-system = [ python3Packages.hatchling ];
  pythonImportsCheck = [ "terrascope" ];

  dependencies = with python3Packages; [
    numpy
    pillow
    pyyaml
    pyshp
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terrascope is an interactive world map for the terminal. It renders countries, place names, live aircraft, city weather, a radar overlay, earthquakes, and day/night bands with curses, Unicode Braille cells, and terminal colors.";
    homepage = "https://github.com/a-shygun/Terrascope";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ undefprophet ];
    mainProgram = "terrascope";
    platforms = lib.platforms.unix;
  };
})
