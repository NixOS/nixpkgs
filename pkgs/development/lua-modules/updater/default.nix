{ buildPythonApplication
, nix
, makeWrapper
, python3Packages
, lib
# , nix-prefetch-git
, nix-prefetch-scripts
, luarocks-nix
}:
let

    path = lib.makeBinPath [ nix nix-prefetch-scripts luarocks-nix ];
in
buildPythonApplication {
  pname = "luarocks-packages-updater";
  version = "0.1";

  format = "other";

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ];
  propagatedBuildInputs = [
    python3Packages.gitpython
  ];

  dontUnpack = true;

  installPhase =
    ''
    mkdir -p $out/bin $out/lib
    cp ${./updater.py} $out/bin/luarocks-packages-updater
    cp ${../../../../maintainers/scripts/pluginupdate.py} $out/lib/pluginupdate.py

    # wrap python scripts
    makeWrapperArgs+=( --prefix PATH : "${path}" --prefix PYTHONPATH : "$out/lib" )
    wrapPythonProgramsIn "$out"
  '';

  shellHook = ''
    export PYTHONPATH="maintainers/scripts:$PYTHONPATH"
    export PATH="${path}:$PATH"
  '';

  meta.mainProgram = "luarocks-packages-updater";
}


