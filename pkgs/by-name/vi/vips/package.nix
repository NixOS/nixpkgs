{
  lib,
  stdenv,
  fetchFromGitHub,

  # Native build inputs
  docbook-xsl-nons,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,

  # Build inputs
  ApplicationServices,
  expat,
  Foundation,
  glib,
  libxml2,
  python3,

  # Optional dependencies
  cfitsio,
  cgif,
  fftw,
  imagemagick,
  lcms2,
  libarchive,
  libexif,
  libheif,
  libhwy,
  libimagequant,
  libjpeg,
  libjxl,
  librsvg,
  libspng,
  libtiff,
  libwebp,
  matio,
  openexr,
  openjpeg,
  openslide,
  pango,
  poppler,

  # passthru
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vips";
  version = "8.16.0";

  outputs = [
    "bin"
    "out"
    "man"
    "dev"
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ "devdoc" ];

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "libvips";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Cx657BEZecPeB9rCeVym3C/d+/u+YLJn9vwxfe8b0dM=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/test/test-suite/images/
    '';
  };

  nativeBuildInputs =
    [
      docbook-xsl-nons
      gobject-introspection
      meson
      ninja
      pkg-config
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      gtk-doc
    ];

  buildInputs =
    [
      glib
      libxml2
      expat
      (python3.withPackages (p: [ p.pycairo ]))

      # Optional dependencies
      cfitsio
      cgif
      fftw
      imagemagick
      lcms2
      libarchive
      libexif
      libheif
      libhwy
      libimagequant
      libjpeg
      libjxl
      librsvg
      libspng
      libtiff
      libwebp
      matio
      openexr
      openjpeg
      openslide
      pango
      poppler
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      ApplicationServices
      Foundation
    ];

  # Required by .pc file
  propagatedBuildInputs = [
    glib
  ];

  mesonFlags =
    [
      (lib.mesonEnable "pdfium" false)
      (lib.mesonEnable "nifti" false)
    ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) (lib.mesonBool "gtk_doc" true)
    ++ lib.optional (imagemagick == null) (lib.mesonEnable "magick" false);

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "vips --version";
      };
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v([0-9.]+)"
      ];
    };
  };

  meta = with lib; {
    changelog = "https://github.com/libvips/libvips/blob/${finalAttrs.src.rev}/ChangeLog";
    homepage = "https://www.libvips.org/";
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      kovirobi
      anthonyroussel
    ];
    pkgConfigModules = [
      "vips"
      "vips-cpp"
    ];
    platforms = platforms.unix;
    mainProgram = "vips";
  };
})
