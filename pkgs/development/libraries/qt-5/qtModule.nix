{ lib, mkDerivation, perl }:

let inherit (lib) licenses maintainers platforms; in

{ self, srcs, patches }:

args:

let
  inherit (args) name;
  version = args.version or srcs."${name}".version;
  src = args.src or srcs."${name}".src;
in

mkDerivation (args // {
  name = "${name}-${version}";
  inherit src;
  patches = args.patches or patches."${name}" or [];

  nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ perl self.qmake ];
  propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);

  outputs = args.outputs or [ "out" "dev" ];
  setOutputFlags = args.setOutputFlags or false;

  preHook = ''
    . ${./hooks/move-qt-dev-tools.sh}
    . ${./hooks/fix-qt-builtin-paths.sh}
  '';

  preConfigure = ''
    ${args.preConfigure or ""}

    fixQtBuiltinPaths . '*.pr?'
  '';

  postFixup = ''
    if [ -d "''${!outputDev}/lib/pkgconfig" ]; then
        find "''${!outputDev}/lib/pkgconfig" -name '*.pc' | while read pc; do
            sed -i "$pc" \
                -e "/^prefix=/ c prefix=''${!outputLib}" \
                -e "/^exec_prefix=/ c exec_prefix=''${!outputBin}" \
                -e "/^includedir=/ c includedir=''${!outputDev}/include"
        done
    fi

    moveQtDevTools

    ${args.postFixup or ""}
  '';

  meta = {
    homepage = http://www.qt.io;
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ qknight ttuegel periklis bkchr ];
    platforms = platforms.unix;
  } // (args.meta or {});
})
