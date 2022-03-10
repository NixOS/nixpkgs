{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, nix-update-script
, # base build deps
  meson
, pkg-config
, ninja
, # docs build deps
  python3
, doxygen
, graphviz
, # GI build deps
  gobject-introspection
, # runtime deps
  glib
, systemd
, lua5_4
, pipewire
, # options
  enableDocs ? true
, enableGI ? stdenv.hostPlatform == stdenv.buildPlatform
}:
let
  mesonEnableFeature = b: if b then "enabled" else "disabled";
in
stdenv.mkDerivation rec {
  pname = "wireplumber";
  version = "0.4.8";

  outputs = [ "out" "dev" ] ++ lib.optional enableDocs "doc";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "wireplumber";
    rev = version;
    sha256 = "sha256-xwfggrjKHh5mZdvH6dKqQo6o1ltxuYdjoGYaWl31C/Y=";
  };

  patches = [
    # backport a patch to fix hangs in some applications
    # ref: https://gitlab.freedesktop.org/pipewire/wireplumber/-/issues/213
    # FIXME: drop this in 0.4.9
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/commit/afbc0ce57aac7aee8dc1651de4620f15c73dbace.patch";
      sha256 = "sha256-8ycFnrzDq7QHgjwJ/772OTMsSsN3m7gjbdvTmlMJ+mU=";
    })
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ] ++ lib.optionals enableDocs [
    graphviz
  ] ++ lib.optionals enableGI [
    gobject-introspection
  ] ++ lib.optionals (enableDocs || enableGI) [
    doxygen
    (python3.withPackages (ps: with ps;
    lib.optionals enableDocs [ sphinx sphinx_rtd_theme breathe ] ++
      lib.optionals enableGI [ lxml ]
    ))
  ];

  buildInputs = [
    glib
    systemd
    lua5_4
    pipewire
  ];

  mesonFlags = [
    "-Dsystem-lua=true"
    "-Delogind=disabled"
    "-Ddoc=${mesonEnableFeature enableDocs}"
    "-Dintrospection=${mesonEnableFeature enableGI}"
    "-Dsystemd-system-service=true"
    "-Dsystemd-system-unit-dir=${placeholder "out"}/lib/systemd/system"
    "-Dsysconfdir=/etc"
  ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "A modular session / policy manager for PipeWire";
    homepage = "https://pipewire.org";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ k900 ];
  };
}
