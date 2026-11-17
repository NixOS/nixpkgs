# Stage 3 presented as an installed compiler, for GHC 6.2.2's own build system.
# bin/ghc wraps stage 3 with its topdir and a side package.conf, and
# bin/ghc-pkg is GHC 6.2.2's ghc-pkg compiled by stage 3.  The side
# package.conf holds parsec, which genprimopcode needs, and the empty packages
# unix, lang, util, text and data, which 6.2.2's own utilities name.
#
# The wrapped ghc calls gcc for .hc files and links, so -fno-pie and -no-pie go
# through the cc wrapper.
{
  stdenv,
  ghc-bootstrap-src,
  gmp,
  tree,
  stage3,
}:

let
  files = "${ghc-bootstrap-src}/ghc622";
  nonPie = {
    NIX_CFLAGS_COMPILE = "-fno-pie";
    NIX_CFLAGS_LINK = "-no-pie";
  };
in
stdenv.mkDerivation {
  pname = "ghc-6.2.2-boot";
  version = "6.2.2";

  dontUnpack = true;

  buildInputs = [ gmp ];

  hardeningDisable = [ "all" ];

  env = nonPie;

  buildPhase = ''
    runHook preBuild

    ulimit -s unlimited
    mkdir -p "$out/bin" "$out/libraries/parsec"
    sh ${files}/tools/side-package-conf.sh "$out" > "$out/package.conf"
    grep -q "$out/libraries/parsec" "$out/package.conf"
    cat > "$out/bin/ghc" <<EOF
    #!${stdenv.shell}
    ulimit -s unlimited 2>/dev/null
    exec ${stage3}/bin/ghc -B${stage3}/topdir -package-conf "$out/package.conf" "\$@"
    EOF
    chmod +x "$out/bin/ghc"
    ln -s ghc "$out/bin/ghc-6.2.2"
    "$out/bin/ghc" --numeric-version | grep -qx 6.2.2

    # ghc-pkg's Main.hs includes ghc/includes/config.h from the configured tree
    tar xjf ${tree.src} ghc-6.2.2/libraries/parsec
    export TMPDIR="$NIX_BUILD_TOP/tmp"; mkdir -p "$TMPDIR"
    P=${tree}/ghc/utils/ghc-pkg
    mkdir ghc-pkg-obj
    (ulimit -v 8000000; "$out/bin/ghc" -v1 --make -cpp -DPKG_TOOL -DWANT_PRETTY -O "-I$P" "-i$P" \
       -odir ghc-pkg-obj -hidir ghc-pkg-obj -o "$out/bin/ghc-pkg.bin" "$P/Main.hs")
    cat > "$out/bin/ghc-pkg" <<EOF
    #!${stdenv.shell}
    exec "$out/bin/ghc-pkg.bin" -f ${stage3}/topdir/package.conf -f "$out/package.conf" \''${1+"\$@"}
    EOF
    chmod +x "$out/bin/ghc-pkg"
    ln -s ghc-pkg "$out/bin/ghc-pkg-6.2.2"

    O="$out/libraries/parsec"
    (cd ghc-6.2.2/libraries/parsec && ulimit -v 8000000 && \
     "$out/bin/ghc" -v1 --make -O -fglasgow-exts -package-name parsec -odir "$O" -hidir "$O" \
       Text/ParserCombinators/Parsec.hs Text/ParserCombinators/Parsec/*.hs)
    (cd "$O" && find . -name '*.o' | sort | xargs ar rcs libHSparsec.a && find . -name '*.o' -delete)
    test $(find "$O" -name '*.hi' | wc -l) = 10

    runHook postBuild
  '';

  dontInstall = true;

  dontStrip = true;

  passthru = { inherit nonPie; };
}
