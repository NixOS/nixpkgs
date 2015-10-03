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

  qtSubmodule = args.qtSubmodule or true;
  dontAddPrefix = args.dontAddPrefix or true;
  dontFixLibtool = args.dontFixLibtool or true;
  configureScript = args.configureScript or "qmake";

  postInstall = ''
    rm "$out/bin/qmake" "$out/bin/qt.conf"

    cat "$out/nix-support/qt-inputs" | while read file; do
      if [[ -h "$out/$file" ]]; then
        rm "$out/$file"
      fi
    done

    cat "$out/nix-support/qt-inputs" | while read file; do
      if [[ -d "$out/$file" ]]; then
        rmdir --ignore-fail-on-non-empty -p "$out/$file"
      fi
    done

    rm "$out/nix-support/qt-inputs"
  '';

  propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);

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
