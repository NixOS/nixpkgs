{ stdenv, nimble, ... }:

{ nimbleMeta, version, src, nativeBuildInputs ? [ ], propagatedBuildInputs ? [ ]
, nimbleInputs ? [ ], preHook ? "", configurePhase ? null, buildPhase ? null
, checkPhase ? null, installPhase ? null, NIX_LDFLAGS ? [ ], nimbleLdFlags ? [ ]
, nimbleLdPath ? [ ], meta ? { }, ... }@attrs:

let
  fillMeta = { description ? nimbleMeta.description, homepage ? nimbleMeta.web
    , maintainers ? [ ], platforms ? stdenv.lib.platforms.unix }@attrs:
    attrs // {
      inherit description platforms;
      inherit (nimbleMeta) license;
      homepage = nimbleMeta.web;
      maintainers = [ stdenv.lib.maintainers.ehmry ] ++ maintainers;
    };

  passthru = {
    inherit nimbleMeta;
    nimbleLdFlags =
      builtins.foldl' (list: pkg: list ++ pkg.passthru.nimbleLdFlags)
      nimbleLdFlags nimbleInputs;
    nimbleLdPath =
      builtins.foldl' (list: pkg: list ++ pkg.passthru.nimbleLdPath)
      nimbleLdPath nimbleInputs;
  };
in stdenv.mkDerivation (attrs // {
  name = "${nimbleMeta.name}-${version}";
  inherit version passthru;
  nimbleMeta = null;

  enableParallelBuilding = true;

  # TODO: the setupHook is slow and hacky because
  # Nimble tries to write a Nimscript file into the dependency
  # packages, see "execNimscript" in the Nimble source.
  setupHook = ./setup-hook.sh;

  nativeBuildInputs = [ nimble ] ++ nativeBuildInputs;
  propagatedBuildInputs =
    builtins.foldl' (list: pkg: list ++ pkg.propagatedBuildInputs) nimbleInputs
    nimbleInputs;

  NIX_LDFLAGS = NIX_LDFLAGS ++ passthru.nimbleLdFlags;
  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath passthru.nimbleLdPath;

  preHook = ''
    export HOME="$NIX_BUILD_TOP"
    export NIMBLE_DIR="$HOME/.nimble"
    export PATH="$NIMBLE_DIR/bin:$PATH"
    ${preHook}
  '';

  configurePhase = if isNull configurePhase then ''
    runHook preConfigure
    mkdir -p $NIMBLE_DIR
    cat <<EOF > $NIMBLE_DIR/packages_official.json
    ${builtins.toJSON (map (drv: drv.passthru.nimbleMeta) nimbleInputs)}
    EOF
    runHook postConfigure
  '' else
    buildPhase;

  buildPhase = if isNull buildPhase then ''
    runHook preBuild
    nimble install
    runHook postBuild
  '' else
    buildPhase;

  checkPhase = if isNull checkPhase then ''
    runHook preCheck
    nimble test
    runHook postCheck
  '' else
    checkPhase;

  installPhase = if isNull installPhase then ''
    runHook preInstall
    if [ -d $NIMBLE_DIR/bin ]; then
        mkdir -p $out
        cp -aL $NIMBLE_DIR/bin $out/bin
    fi
    if [ ! -d $NIMBLE_DIR/pkgs/$name ]; then
        echo A $name package not found, wrong package version?
        echo -n "Found packages: "
        ls $NIMBLE_DIR/pkgs
        exit 1
    fi
    mkdir -p $out/nimble-pkgs
    cp -a $NIMBLE_DIR/pkgs/$name $out/nimble-pkgs
    runHook postInstall
  '' else
    installPhase;

  meta = fillMeta meta;
})
