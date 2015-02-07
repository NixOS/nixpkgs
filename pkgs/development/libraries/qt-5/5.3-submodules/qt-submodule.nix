{ stdenv, mkDerivation
, srcs, version
, lndir
, base
}:

with stdenv.lib;

args:

mkDerivation (args // {

  name = "${args.name}-${version}";
  inherit version;

  srcs = args.srcs or [srcs."${args.name}-opensource-src"];

  preConfigure = ''
    mkdir -p "$out"

    for qtInput in ${concatStringsSep " " args.qtInputs}; do
      lndir "$qtInput" "$out"
    done

    # Only this package's nix-support files go in $out
    rm -fr $out/nix-support

    # Override hardcoded paths in qmake
    rm -f $out/bin/qmake
    cp "${base}/bin/qmake" "$out/bin/qmake"
    rm -f $out/bin/qt.conf
    cat <<EOF >$out/bin/qt.conf
[Paths]
Prefix = $out
EOF
    export PATH=$out/bin:$PATH
  '' + (args.preConfigure or "");

  dontAddPrefix = args.dontAddPrefix or true;
  dontFixLibtool = args.dontFixLibtool or true;
  configureScript = args.configureScript or "qmake";

  postInstall = ''
    rm "$out/bin/qmake" "$out/bin/qt.conf"
  '';

  propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);

  nativeBuildInputs = [ lndir ] ++ (args.nativeBuildInputs or []);

  enableParallelBuilding =
    args.enableParallelBuilding or true; # often fails on Hydra, as well as qt4

  meta = args.meta or {
    homepage = http://qt-project.org;
    description = "A cross-platform application framework for C++";
    license = "GPL/LGPL";
    maintainers = with maintainers; [ bbenoist qknight ttuegel ];
    platforms = platforms.linux;
  };

})
