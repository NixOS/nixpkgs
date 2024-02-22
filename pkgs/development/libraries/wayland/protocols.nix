{ lib, stdenv, fetchurl
, pkg-config
, meson, ninja, wayland-scanner
, python3, wayland
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayland-protocols";
  version = "1.33";

  # https://gitlab.freedesktop.org/wayland/wayland-protocols/-/issues/48
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform && stdenv.hostPlatform.linker == "bfd" && wayland.withLibraries;

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/${finalAttrs.pname}/-/releases/${finalAttrs.version}/downloads/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    hash = "sha256-lPDFCwkNbmGgP2IEhGexmrvoUb5OEa57NvZfi5jDljo=";
  };

  postPatch = lib.optionalString finalAttrs.doCheck ''
    patchShebangs tests/
  '';

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja wayland-scanner ];
  nativeCheckInputs = [ python3 wayland ];

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
    homepage    = "https://gitlab.freedesktop.org/wayland/wayland-protocols";
    license     = lib.licenses.mit; # Expat version
    platforms   = lib.platforms.all;
    maintainers = with lib.maintainers; [ primeos ];
    pkgConfigModules = [ "wayland-protocols" ];
  };

  passthru.version = finalAttrs.version;
  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };
})
