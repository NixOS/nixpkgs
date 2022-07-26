{ stdenv, lib, perl, cmake, ninja, writeText }:

{ self, srcs, patches ? [ ] }:

args:

let
  inherit (args) pname;
  version = args.version or srcs.${pname}.version;
  src = args.src or srcs.${pname}.src;
in
stdenv.mkDerivation (args // {
  inherit pname version src;
  patches = args.patches or patches.${pname} or [ ];

  buildInputs = args.buildInputs or [ ];
  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
    perl
    cmake
    ninja
  ];
  propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or [ ]);

  outputs = args.outputs or [ "out" "dev" ];

  dontWrapQtApps = args.dontWrapQtApps or true;
  postInstall = ''
    if [ ! -z "$dev" ]; then
      mkdir "$dev"
      for dir in bin libexec mkspecs
      do
        moveToOutput "$dir" "$dev"
      done
    fi
    ${args.postInstall or ""}
  '';

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ milahu nickcao ];
    platforms = platforms.linux;
  } // (args.meta or { });
})
