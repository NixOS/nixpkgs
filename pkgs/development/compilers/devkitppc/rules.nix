{ stdenvNoCC
, callPackage
, lib
}:

let
  sources = callPackage ./sources.nix { };
in stdenvNoCC.mkDerivation rec {
  pname = "devkitPPC-rules";
  src = sources.rules;
  inherit (src) version;

  patches = [
    ./0001-Use-generate_compile_commands-from-PATH.patch
    ./0002-Allow-installing-to-another-prefix.patch
  ];

  noConfigurePhase = true;
  noBuildPhase = true;

  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    make install PREFIX="$out"
    runHook postInstall
  '';

  meta = {
    description = "Makefile includes for devkitPPC";
    homepage = "https://github.com/devkitPro/devkitppc-rules";
    # FIXME https://github.com/devkitPro/devkitppc-rules/issues/7
    #license = ???;
    maintainers = [ lib.maintainers.novenary ];
    platforms = lib.platforms.unix;
  };
}
