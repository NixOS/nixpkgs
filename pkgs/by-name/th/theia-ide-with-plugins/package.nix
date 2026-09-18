{
  lib,
  stdenv,
  buildEnv,
  symlinkJoin,
  theia-ide,
  makeWrapper,
  plugins ? [ ],
}:

let
  wrappedVersion = lib.getVersion theia-ide;
  wrappedPkgName = theia-ide.pname;
  combinedPluginsDrv = buildEnv {
    name = "theia-plugins";
    paths = plugins;
    postBuild = ''
      mkdir -p $out/share/theia-ide/resources/app/plugins
      if [ -d "$out/share/vscode/extensions" ]
      then
        mv $out/share/vscode/extensions/* $out/share/theia-ide/resources/app/plugins/
        rm -r $out/share/vscode
      fi
    '';
  };
in
symlinkJoin {
  pname = "${wrappedPkgName}-with-plugins";
  version = wrappedVersion;
  nativeBuildInputs = [ makeWrapper ];
  paths = [
    theia-ide
    combinedPluginsDrv
  ];
  postBuild = ''
    mv $out/bin/theia-ide $out/bin/.theia-ide-wrapped
    makeWrapper $out/bin/.theia-ide-wrapped $out/bin/theia-ide \
      --set THEIA_PLUGINS local-dir:$out/share/theia-ide/resources/app/plugins
  '';
  strictDeps = true;
  __structuredAttrs = true;
  meta = theia-ide.meta;
}
