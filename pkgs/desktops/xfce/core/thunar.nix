{ stdenv, buildEnv, runCommand, makeWrapper, lndir, thunar-build
, thunarPlugins ? []
}:

with stdenv.lib; 

let

  build = thunar-build;

  replaceLnExeListWithWrapped = exeDir: exeNameList: mkWrapArgs: ''
    exeDir="${exeDir}"
    oriDir=`realpath -e "$exeDir"`
    unlink "$exeDir"
    mkdir -p "$exeDir"
    lndir "$oriDir" "$exeDir"

    exeList="${concatStrings (intersperse " " (map (x: "${exeDir}/${x}") exeNameList))}"

    for exe in $exeList; do
      oriExe=`realpath -e "$exe"`
      rm -f "$exe"
      makeWrapper "$oriExe" "$exe" ${concatStrings (intersperse " " mkWrapArgs)}
    done
  '';

  name = "${build.p_name}-${build.ver_maj}.${build.ver_min}";

  meta = {
    inherit (build.meta) homepage license platforms;

    description = build.meta.description + optionalString
      (0 != length thunarPlugins)
      " (with plugins: ${concatStrings (intersperse ", " (map (x: x.name) thunarPlugins))})";
    maintainers = build.meta.maintainers /*++ [ jraygauthier ]*/;
  };

in

# TODO: To be replaced with `buildEnv` awaiting missing features.
runCommand name {
  inherit build;
  inherit meta;

  nativeBuildInputs = [ makeWrapper lndir ];

  dontPatchELF = true;
  dontStrip = true;

} 
(let
  buildWithPlugins = buildEnv {
    name = "thunar-build-with-plugins";
    paths = [ build ] ++ thunarPlugins;
  };

in ''
  mkdir -p $out
  pushd ${buildWithPlugins} > /dev/null
  for d in `find . -maxdepth 1 -name "*" -printf "%f\n" | tail -n+2`; do
    ln -s "${buildWithPlugins}/$d" "$out/$d"
  done
  popd > /dev/null

  ${replaceLnExeListWithWrapped "$out/bin" [ "thunar" "thunar-settings" ] [
    "--set THUNARX_MODULE_DIR \"${buildWithPlugins}/lib/thunarx-2\""
  ]}
'')
