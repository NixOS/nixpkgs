{
  stdenv,
  lib,
  writeScript,
  icu,
}:

{ version, src, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "native_natural_sort";
  inherit version src;
  inherit (src) passthru;

  # native_natural_sort's Linux backend (LinuxCollationLoader, see
  # lib/src/linux/collation_ffi.dart) discovers libicui18n.so by listing only
  # a few hard-coded system directories (/usr/lib/<triplet>, /lib/<triplet>,
  # /app/lib) and never consults LD_LIBRARY_PATH for that listing.  On NixOS
  # ICU lives in the store, so Flutter apps using this package crash with
  # "LinuxCollationLoader: no libicui18n.so found on the system"
  # (https://github.com/NixOS/nixpkgs/issues/556264).
  #
  # Patch the search path to include nixpkgs' ICU (the full store path is
  # substituted in below and baked into the compiled snapshot), and inject
  # ICU into consumers' runtimeDependencies so it ends up in the runtime
  # closure (and the wrapper's LD_LIBRARY_PATH).
  patches = [ ./icu.patch ];

  setupHook = writeScript "${finalAttrs.pname}-setup-hook" ''
    nativeNaturalSortIcuHook() {
      runtimeDependencies+=('${lib.getLib icu}')
    }

    preFixupHooks+=(nativeNaturalSortIcuHook)
  '';

  postPatch = ''
    substituteInPlace lib/src/linux/collation_ffi.dart \
      --replace-fail '@icuLib@' '${lib.getLib icu}/lib'
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
})
