{ kdeDerivation, lib, debug, srcs }:

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

  meta = {
    platforms = lib.platforms.linux;
    homepage = "http://www.kde.org";
  } // (args.meta or {});
})
