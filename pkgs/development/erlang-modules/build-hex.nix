{ stdenv, erlang, rebar3, openssl, libyaml }:

{ name, version
, buildInputs ? [], erlangDeps ? []
, postPatch ? ""
, ... }@attrs:

with stdenv.lib;

stdenv.mkDerivation (attrs // {
  name = "${name}-${version}";

  buildInputs = buildInputs ++ [ erlang rebar3 openssl libyaml ];

  postPatch = ''
    rm -f rebar rebar3
    if [ -e "src/${name}.app.src" ]; then
      sed -i -e 's/{ *vsn *,[^}]*}/{vsn, "${version}"}/' "src/${name}.app.src"
    fi
    ${postPatch}
  '';

  # unpackCmd = "(mkdir cron && cd cron && sh $curSrc)";
  unpackCmd = ''
    tar -xf $curSrc contents.tar.gz
    mkdir contents
    tar -C contents -xzf contents.tar.gz
    # rm -rf CHECKSUM contents.tar.gz metadata.config VERSION
  '';

  configurePhase = let
    getDeps = drv: [drv] ++ (map getDeps drv.erlangDeps);
    recursiveDeps = uniqList {
       inputList = flatten (map getDeps erlangDeps);
    };
  in ''
    runHook preConfigure
    mkdir -p _build/default/lib/
    ${concatMapStrings (dep: ''
      header "linking erlang dependency ${dep}"
      ln -s "${dep}" "_build/default/lib/${dep.packageName}"
      stopNest
    '') recursiveDeps}
    ls -laR
    cat rebar.config || true
    cat rebar.lock || true
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    DEBUG=1 HOME=. rebar3 update
    DEBUG=1 HOME=. rebar3 compile
    runHook postBuild
  '';

  installPhase = ''
    ls -laR
    runHook preInstall
    mkdir "$out"
    for reldir in src ebin priv include; do
      fd="_build/default/lib/${name}/$reldir"
      [ -d "$fd" ] || continue
      cp -Hrt "$out" "$fd"
      success=1
    done
    runHook postInstall
  '';

  # src = fetchurl {
  #   url = "https://s3.amazonaws.com/s3.hex.pm/tarballs/${name}-${version}.tar";
  #   sha256 = "1zjgbarclhh10cpgvfxikn9p2ay63rajq96q1sbz9r9w6v6p8jm9";
  # };

  passthru = {
    packageName = name;
    inherit erlangDeps;
  };
})
