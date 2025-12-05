{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  systemd,
  libinput,
  pugixml,
  cairo,
  xorg,
  gtk3-x11,
  pkg-config,
  cmake,
  withPantheon ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "touchegg";
  version = "2.0.18";

  src = fetchFromGitHub {
    owner = "JoseExposito";
    repo = "touchegg";
    tag = finalAttrs.version;
    hash = "sha256-7LJ5gD2e6e4edKDabqmsiXTdNKJ39557Q4sEGWF8H1U=";
  };

  patches = [
    (fetchpatch {
      name = "cmake-4-support.patch";
      url = "https://github.com/JoseExposito/touchegg/commit/953c4227253d91c73f5ce46f89947262ebf45b18.patch";
      hash = "sha256-q/rKXLN8wqisw3QfqEtu1ZaJonOYzkYLFRECNYB620g=";
    })
  ]
  ++ lib.optionals withPantheon [
    # Required for the next patch to apply
    # Reverts https://github.com/JoseExposito/touchegg/pull/603
    (fetchpatch {
      url = "https://github.com/JoseExposito/touchegg/commit/34e947181d84620021601e7f28deb1983a154da8.patch";
      hash = "sha256-qbWwmEzVXvDAhhrGvMkKN4YNtnFfRW+Yra+i6VEQX4g=";
      revert = true;
    })
    # Disable per-application gesture by default to make sure the default
    # config does not conflict with Pantheon switchboard settings.
    (fetchpatch {
      url = "https://github.com/elementary/os-patches/commit/7d9b133e02132d7f13cf2fe850b2fe4c015c3c5e.patch";
      hash = "sha256-ZOGVkxiXoTORXC6doz5r9IObAbYjhsDjgg3HtzlTSUc=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    systemd
    libinput
    pugixml
    cairo
    gtk3-x11
  ]
  ++ (with xorg; [
    libX11
    libXtst
    libXrandr
    libXi
    libXdmcp
    libpthreadstubs
    libxcb
  ]);

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/JoseExposito/touchegg";
    description = "Linux multi-touch gesture recognizer";
    mainProgram = "touchegg";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
})
