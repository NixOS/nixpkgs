{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  meson,
  ninja,
  vala,
  pkg-config,
  wrapGAppsHook3,
  libzim-glib,
  sqlite,
  webkitgtk_4_1,
  tinysparql,
  libxml2,
  libisocodes,
  libhandy,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "web-archives";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "birros";
    repo = "web-archives";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EYHChI+4tpjRp4KveHTB+5BSLtw0YLp5z2JJmA0xTlM=";
  };

  web-archive-darkreader = fetchurl {
    # This is the same with build-aux/darkreader/Makefile
    url = "https://github.com/birros/web-archives-darkreader/releases/download/v0.0.1/web-archives-darkreader_v0.0.1.js";
    hash = "sha256-juhAqs2eCYZKerLnX3NvaW3NS0uOhqB7pyf/PRDvMqE=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
        "'make', '-C', 'build-aux/darkreader'" \
        "'cp', '${finalAttrs.web-archive-darkreader}', 'build-aux/darkreader/web-archives-darkreader.js'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libzim-glib
    sqlite
    webkitgtk_4_1
    tinysparql
    libxml2
    libisocodes
    libhandy
    glib-networking
  ];

  strictDeps = true;

  passthru = {
    inherit (finalAttrs) web-archive-darkreader;
  };

  meta = {
    description = "Web archives reader offering the ability to browse offline millions of articles";
    homepage = "https://github.com/birros/web-archives";
    license = lib.licenses.gpl3Plus;
    mainProgram = "web-archives";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
