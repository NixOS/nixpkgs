{ stdenv
, lib
, fetchFromGitHub
, fetchpatch2
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, vips
, gtk4
, python3
}:

stdenv.mkDerivation rec {
  pname = "vipsdisp";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "jcupitt";
    repo = "vipsdisp";
    rev = "v${version}";
    hash = "sha256-a8wqDTVZnhqk0zHAuGvwjtJTM0irN2tkRIjx6sIteV0=";
  };

  patches = [
    # Fixes build with clang
    (fetchpatch2 {
      url = "https://github.com/jcupitt/vipsdisp/commit/e95888153838d6e58d5b9fd7c08e3d03db38e8b1.patch?full_index=1";
      hash = "sha256-MtQ9AMvl2MkHSLyOuwFVbmNiCEoPPnrK3EoUdvqEtOo=";
    })
  ];

  postPatch = ''
    chmod +x ./meson_post_install.py
    patchShebangs ./meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    vips
    gtk4
    python3
  ];

  # No tests implemented.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jcupitt/vipsdisp";
    description = "Tiny image viewer with libvips";
    license = licenses.mit;
    mainProgram = "vipsdisp";
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = platforms.unix;
  };
}
