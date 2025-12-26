{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  python3,
  wayland,
  gitUpdater,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayland-protocols";
  version = "1.45";

  doCheck =
    stdenv.hostPlatform == stdenv.buildPlatform
    &&
      # https://gitlab.freedesktop.org/wayland/wayland-protocols/-/issues/48
      stdenv.hostPlatform.linker == "bfd"
    &&
      # Even with bfd linker, the above issue occurs on platforms with stricter linker requirements
      # https://gitlab.freedesktop.org/wayland/wayland-protocols/-/issues/48#note_1453201
      !(stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isBigEndian)
    && lib.meta.availableOn stdenv.hostPlatform wayland;

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/${finalAttrs.pname}/-/releases/${finalAttrs.version}/downloads/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    hash = "sha256-TSsqnj4JnQF9yBB78cM00nu4fZ5K/xmgyNhW0XzUHvA=";
  };

  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
    patchShebangs tests/
  '';

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    wayland-scanner
  ];
  nativeCheckInputs = [
    python3
    wayland
  ];
  checkInputs = [ wayland ];
  strictDeps = true;

  mesonFlags = [ "-Dtests=${lib.boolToString finalAttrs.finalPackage.doCheck}" ];

  meta = {
    description = "Wayland protocol extensions";
    longDescription = ''
      wayland-protocols contains Wayland protocols that add functionality not
      available in the Wayland core protocol. Such protocols either add
      completely new functionality, or extend the functionality of some other
      protocol either in Wayland core, or some other protocol in
      wayland-protocols.
    '';
    homepage = "https://gitlab.freedesktop.org/wayland/wayland-protocols";
    license = lib.licenses.mit; # Expat version
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ wineee ];
    pkgConfigModules = [ "wayland-protocols" ];
  };

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.freedesktop.org/wayland/wayland-protocols.git";
  };
  passthru.version = finalAttrs.version;
  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };
})
