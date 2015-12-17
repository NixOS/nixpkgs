{ stdenv, erlang, rebar, openssl, libyaml }:

{ name, version
, buildInputs ? [], erlangDeps ? []
, postPatch ? ""
, meta ? {}
, ... }@attrs:

with stdenv.lib;

stdenv.mkDerivation (attrs // {
  name = "${name}-${version}";

  buildInputs = buildInputs ++ [ erlang rebar openssl libyaml ];

  postPatch = ''
    rm -f rebar
    if [ -e "src/${name}.app.src" ]; then
      sed -i -e 's/{ *vsn *,[^}]*}/{vsn, "${version}"}/' "src/${name}.app.src"
    fi
    ${postPatch}
  '';

  configurePhase = let
    getDeps = drv: [drv] ++ (map getDeps drv.erlangDeps);
    recursiveDeps = uniqList {
       inputList = flatten (map getDeps erlangDeps);
    };
  in ''
    runHook preConfigure
    ${concatMapStrings (dep: ''
      header "linking erlang dependency ${dep}"
      mkdir deps
      ln -s "${dep}" "deps/${dep.packageName}"
      stopNest
    '') recursiveDeps}
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    rebar compile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    for reldir in src ebin priv include; do
      [ -e "$reldir" ] || continue
      mkdir "$out"
      cp -rt "$out" "$reldir"
      success=1
    done
    runHook postInstall
  '';

  meta = {
    inherit (erlang.meta) platforms;
  } // meta;

  passthru = {
    packageName = name;
    inherit erlangDeps;
  };
})
