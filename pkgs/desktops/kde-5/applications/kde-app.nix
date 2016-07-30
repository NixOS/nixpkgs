{ kdeDerivation, lib, debug, srcs, cmake, pkgconfig }:

args:

let
  inherit (args) name;
  sname = args.sname or name;
  inherit (srcs."${sname}") src version;
in
kdeDerivation (args // {
  name = "${name}-${version}";
  inherit src;

  cmakeFlags =
    (args.cmakeFlags or [])
    ++ [ "-DBUILD_TESTING=OFF" ]
    ++ lib.optional debug "-DCMAKE_BUILD_TYPE=Debug";

  nativeBuildInputs =
    (args.nativeBuildInputs or [])
    ++ [ cmake pkgconfig ];

  meta = {
    platforms = lib.platforms.linux;
    homepage = "http://www.kde.org";
  } // (args.meta or {});
})
