{
  stdenv,
  icu,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "native_natural_sort";
  inherit version src;
  inherit (src) passthru;

  # The Linux backend (LinuxCollationLoader, see lib/src/linux/collation_ffi.dart)
  # looks up libicui18n.so by scanning only a handful of hard-coded system
  # directories and never consults LD_LIBRARY_PATH.  On NixOS ICU lives in the
  # store, so Flutter apps using this package crash with
  # "LinuxCollationLoader: no libicui18n.so found on the system"
  # (https://github.com/NixOS/nixpkgs/issues/556264).
  #
  # Add nixpkgs' ICU to the scanned directories.  The resulting string ends up
  # in the release AOT snapshot (libapp.so), so ICU stays in the closure
  # without a runtimeDependencies hook.
  postPatch = ''
    substituteInPlace lib/src/linux/collation_ffi.dart \
      --replace-fail "'/app/lib', // Flatpak runtime layout" "'/app/lib', '${icu}/lib',"
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
