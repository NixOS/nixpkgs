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
  version = "1.38";

  doCheck =
    stdenv.hostPlatform == stdenv.buildPlatform
    &&
      # https://gitlab.freedesktop.org/wayland/wayland-protocols/-/issues/48
      stdenv.hostPlatform.linker == "bfd"
    && lib.meta.availableOn stdenv.hostPlatform wayland;

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/${finalAttrs.pname}/-/releases/${finalAttrs.version}/downloads/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    hash = "sha256-/xcpLAUVnSsgzmys/kLX4xooGY+hQpp2mwOvfDhYHb4=";
  };

  postPatch = lib.optionalString finalAttrs.doCheck ''
    patchShebangs tests/
  '';

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    wayland-scanner
  ];
  nativeCheckInputs = [ python3 ];
  checkInputs = [ wayland ];

  mesonFlags = [ "-Dtests=${lib.boolToString finalAttrs.doCheck}" ];

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
    maintainers = with lib.maintainers; [ primeos ];
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
