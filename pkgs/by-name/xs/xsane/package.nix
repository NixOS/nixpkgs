{
  lib,
  stdenv,
  fetchFromGitLab,
  sane-backends,
  sane-frontends,
  libX11,
  gtk2,
  pkg-config,
  libpng,
  libusb-compat-0_1,
  gimpSupport ? false,
  gimp,
  nix-update-script,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "xsane";
  version = "0.999";

  src = fetchFromGitLab {
    owner = "frontend";
    group = "sane-project";
    repo = "xsane";
    rev = version;
    hash = "sha256-oOg94nUsT9LLKnHocY0S5g02Y9a1UazzZAjpEI/s+yM=";
  };

  # add all fedora patchs. fix gcc-14 build among other things
  # https://src.fedoraproject.org/rpms/xsane/tree/main
  patches =
    let
      fetchFedoraPatch =
        { name, hash }:
        fetchpatch {
          inherit name hash;
          url = "https://src.fedoraproject.org/rpms/xsane/raw/846ace0a29063335c708b01e9696eda062d7459c/f/${name}";
        };
    in
    map fetchFedoraPatch [
      {
        name = "0001-Follow-new-convention-for-registering-gimp-plugin.patch";
        hash = "sha256-yOY7URyc8HEHHynvdcZAV1Pri31N/rJ0ddPavOF5zLw=";
      }
      {
        name = "xsane-0.995-close-fds.patch";
        hash = "sha256-qE7larHpBEikz6OaOQmmi9jl6iQxy/QM7iDg9QrVV1o=";
      }
      {
        name = "xsane-0.995-xdg-open.patch";
        hash = "sha256-/kHwwuDC2naGEp4NALfaJ0pJe+9kYhV4TX1eGeARvq8=";
      }
      {
        name = "xsane-0.996-no-eula.patch";
        hash = "sha256-CYmp1zFg11PUPz9um2W7XF6pzCzafKSEn2nvPiUSxNo=";
      }
      {
        name = "xsane-0.997-ipv6.patch";
        hash = "sha256-D3xH++DHxyTKMxgatU+PNCVN1u5ajPc3gQxvzhMYIdM=";
      }
      {
        name = "xsane-0.997-off-root-build.patch";
        hash = "sha256-2LXQfMbvqP+TAhAmxRe6pBqNlSX4tVjhDkBHIfX9HcA=";
      }
      {
        name = "xsane-0.998-desktop-file.patch";
        hash = "sha256-3xEj6IaOk/FS8pv+/yaNjZpIoB+0Oei0QB9mD4/owkM=";
      }
      {
        name = "xsane-0.998-libpng.patch";
        hash = "sha256-0z292+Waa2g0PCQpUebdWprl9VDyBOY0XgqMJaIcRb8=";
      }
      {
        name = "xsane-0.998-preview-selection.patch";
        hash = "sha256-TZ8vRA+0qPY2Rqz0VNHjgkj3YPob/BW+zBoVqxnUhb8=";
      }
      {
        name = "xsane-0.998-wmclass.patch";
        hash = "sha256-RubFOs+hsZS+GdxF0yvLSy4v+Fi6vb9G6zfwWZcUlkY=";
      }
      {
        name = "xsane-0.999-lcms2.patch";
        hash = "sha256-eiAxa1lhFrinqBvlIhH+NP7WBKk0Plf2S+OVTcpxXac=";
      }
      {
        name = "xsane-0.999-man-page.patch";
        hash = "sha256-4g0w4x9boAIOA6s5eTzKMh2mkkRKtF1TZ9KgHNTDaAg=";
      }
      {
        name = "xsane-0.999-no-file-selected.patch";
        hash = "sha256-e/QKtvsIwU5yy0SJKAEAmhmCoxWqV6FHmAW41SbW/eI=";
      }
      {
        name = "xsane-0.999-pdf-no-high-bpp.patch";
        hash = "sha256-o3LmOvgERuB9CQ8RL2Nd40h1ePuuuGMSK1GN68QlJ6s=";
      }
      {
        name = "xsane-0.999-signal-handling.patch";
        hash = "sha256-JU9BJ6UIDa1FsuPaQKsxcjxvsJkwgmuopIqCVWY3LQ0=";
      }
      {
        name = "xsane-0.999-snprintf-update.patch";
        hash = "sha256-bSTeoIOLeJ4PEsBHR+ZUQLPmrc0D6aQzyJGlLVhXt8o=";
      }
      {
        name = "xsane-configure-c99.patch";
        hash = "sha256-ukaNGgzCGiQwbOzSguAqBIKOUzXofSC3lct812U/8gY=";
      }
    ];

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/xsane-back-gtk.c
    chmod a+rX -R .
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpng
    libusb-compat-0_1
    sane-backends
    sane-frontends
    libX11
    gtk2
  ]
  ++ lib.optional gimpSupport gimp;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "http://www.sane-project.org/";
    description = "Graphical scanning frontend for sane";
    mainProgram = "xsane";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ melling ];
  };
}
