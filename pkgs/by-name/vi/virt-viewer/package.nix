{
  lib,
  stdenv,
  bash-completion,
  fetchurl,
  fetchpatch,
  gdbm,
  glib,
  gst_all_1,
  gsettings-desktop-schemas,
  gtk-vnc,
  gtk3,
  intltool,
  libcap,
  libgovirt,
  # Currently unsupported. According to upstream, libgovirt is for a very narrow
  # use-case and we don't currently cover it in Nixpkgs. It's safe to disable.
  # https://gitlab.com/virt-viewer/virt-viewer/-/issues/100#note_1265011223
  # Can be enabled again once this is merged:
  # https://gitlab.com/virt-viewer/virt-viewer/-/merge_requests/129
  ovirtSupport ? false,
  libvirt,
  libvirt-glib,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  shared-mime-info,
  spice-gtk,
  spice-protocol,
  spiceSupport ? true,
  vte,
  wrapGAppsHook3,
}:
stdenv.mkDerivation rec {
  pname = "virt-viewer";
  version = "11.0";

  src = fetchurl {
    url = "https://releases.pagure.org/virt-viewer/virt-viewer-${version}.tar.xz";
    sha256 = "sha256-pD+iMlxMHHelyMmAZaww7wURohrJjlkPIjQIabrZq9A=";
  };

  patches = [
    # Fix build with meson 0.61. Should be fixed in the next release.
    # https://gitlab.com/virt-viewer/virt-viewer/-/merge_requests/120
    (fetchpatch {
      url = "https://gitlab.com/virt-viewer/virt-viewer/-/commit/98d9f202ef768f22ae21b5c43a080a1aa64a7107.patch";
      hash = "sha256-3AbnkbhWOh0aNjUkmVoSV/9jFQtvTllOr7plnkntb2o=";
    })
  ];

  nativeBuildInputs = [
    glib
    intltool
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
    wrapGAppsHook3
  ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    bash-completion
    glib
    gsettings-desktop-schemas
    gtk-vnc
    gtk3
    libvirt
    libvirt-glib
    libxml2
    vte
  ]
  ++ lib.optionals ovirtSupport [
    libgovirt
  ]
  ++ lib.optionals spiceSupport (
    [
      gdbm
      spice-gtk
      spice-protocol
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libcap
    ]
  );

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = lib.optional spiceSupport spice-gtk;

  mesonFlags = [
    (lib.mesonEnable "ovirt" ovirtSupport)
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs build-aux/post_install.py
  '';

  meta = with lib; {
    description = "Viewer for remote virtual machines";
    maintainers = with maintainers; [
      raskin
      atemu
    ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl2;
    mainProgram = "virt-viewer";
  };
  passthru = {
    updateInfo = {
      downloadPage = "https://virt-manager.org/download.html";
    };
  };
}
