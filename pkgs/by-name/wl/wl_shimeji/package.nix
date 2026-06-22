{
  lib,
  symlinkJoin,
  wl_shimeji-unwrapped,
  python3,
  python3Packages,
}:

let
  unwrapped = wl_shimeji-unwrapped;
in
symlinkJoin {
  pname = "wl_shimeji";
  inherit (unwrapped) version;

  paths = [
    unwrapped
  ];

  nativeBuildInputs = [
    python3Packages.wrapPython
  ];

  pythonInputs = with python3Packages; [
    pillow
  ];

  postBuild = ''
    buildPythonPath "$pythonInputs"

    wrapProgram $out/bin/shimejictl \
      --prefix PATH : $program_PATH \
      --set PYTHONHOME ${python3} \
      --set PYTHONPATH $program_PYTHONPATH
  '';

  meta = unwrapped.meta // {
    hydraPlatforms = [ ];
    priority = (unwrapped.meta.priority or lib.meta.defaultPriority) - 1;
  };
}
