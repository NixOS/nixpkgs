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
  version = "0.4.7";

  outputs = [ "out" "dev" ] ++ lib.optional enableDocs "doc";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "wireplumber";
    rev = version;
    sha256 = "sha256-yp4xtp+s+h+43LGVtYonoJ2tQaLRfwyMY4fp8z1l0CM=";
  };

  patches = [
    # backport a fix for default device selection
    # FIXME remove this after 0.4.8
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/commit/211f1e6b6cd4898121e4c2b821fae4dea6cc3317.patch";
      sha256 = "sha256-EGcbJ8Rq/5ft6SV0VC+mTkhVE7Ycze4TL6AVc9KH7+M=";
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
