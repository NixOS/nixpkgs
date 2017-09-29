{ buildEnv, makeWrapper, caja, extensions ? [] }:

buildEnv {
  name = "cajaWithExtensions-${caja.version}";
  meta = caja.meta // { description = "File manager (including extensions) for the MATE desktop"; };
  paths = [ caja ] ++ extensions;
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/caja" --set CAJA_EXTENSION_DIRS "$out/lib/caja/extensions-2.0"
  '';
}
