{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  gobject-introspection,
  gtk4,
  meson,
  ninja,
  pkg-config,

  json-glib,
  libadwaita,
  libxml2,
}:

stdenv.mkDerivation {
  pname = "text-engine";
  version = "0.1.1-unstable-2024-09-16";

  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = "text-engine";
    rev = "4c26887556fd8e28211324c4058d49508eb5f557";
    hash = "sha256-0rMBz2s3wYv7gZiJTj8rixWxBjT6Dd6SaINP8kDbTyw=";
  };

  nativeBuildInputs = [
    gobject-introspection
    gtk4
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libadwaita
    libxml2
  ];

  postPatch = ''
    # See https://github.com/mjakeman/text-engine/pull/42
    substituteInPlace src/meson.build \
      --replace-fail "dependency('json-glib-1.0')," ""
  '';

  meta = {
    description = "Rich text framework for GTK";
    mainProgram = "text-engine-demo";
    homepage = "https://github.com/mjakeman/text-engine";
    license = with lib.licenses; [
      mpl20
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ foo-dogsquared ];
  };
}
