{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  pugixml,
  fmt,
  html-tidy,
  enablePython? false,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "syndication-domination";
  # author extraction feature needed by gnome-feeds
  version = "1.0-unstable-2023-03-25";

  src = fetchFromGitLab {
    owner = "gabmus";
    repo = "syndication-domination";
    rev = "75920321062d682437f3fb0319dad227d8b18f6c";
    hash = "sha256-fOlE9CsNcmGkVBXaqYHxLDWB8voeRp46+dZYIJIwg7o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    pugixml
    fmt
    html-tidy
  ] ++ lib.optionals enablePython [
    python3Packages.python
    python3Packages.pybind11
  ];

  mesonFlags = [
    (lib.mesonBool "TO_JSON_BINARY" true)
    (lib.mesonBool "PYTHON_BINDINGS" enablePython)
  ];

  meta = {
    description = "RSS/Atom parser written in C++ with Python binding";
    homepage = "https://gitlab.com/gabmus/syndication-domination";
    license = lib.licenses.agpl3Only;
    mainProgram = "SyndicationDomination";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
  };
}
