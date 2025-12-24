{
  stdenv,
  fetchFromGitHub,
  meson,
  cmake,
  ninja,
  llvmPackages_12,
  pkg-config,
  vapoursynth,
  libxml2,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-akarin";
  version = "0.95";

  src = fetchFromGitHub {
    owner = "AkarinVS";
    repo = "vapoursynth-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kHB6xra5RLLI4Rm822WvL8LLqTOqtGSnWzIMeJXam2s=";
  };

  # The meson build is configured to install the library aside vapoursynth
  preConfigure = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    llvmPackages_12.libllvm
    vapoursynth
    libxml2
  ];

  meta = {
    description = "Enhanced LLVM-based std.Expr plugin for vapoursynth";
    homepage = "https://github.com/AkarinVS/vapoursynth-plugin";
    changelog = "https://github.com/AkarinVS/vapoursynth-plugin/releases";
    platforms = lib.platforms.all;
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
