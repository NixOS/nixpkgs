{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoreconfHook,
  libxml2,
  findXMLCatalogs,
  gettext,
  python3,
  ncurses,
  libgcrypt,
  cryptoSupport ? false,
  pythonSupport ? libxml2.pythonSupport,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxslt";
  version = "1.1.43";

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
    "devdoc"
  ]
  ++ lib.optional pythonSupport "py";
  outputMan = "bin";

  src = fetchurl {
    url = "mirror://gnome/sources/libxslt/${lib.versions.majorMinor finalAttrs.version}/libxslt-${finalAttrs.version}.tar.xz";
    hash = "sha256-Wj1rODylr8I1sXERjpD1/2qifp/qMwMGUjGm1APwGDo=";
  };

  patches = [
    # Fix use-after-free with key data stored cross-RVT
    # https://gitlab.gnome.org/GNOME/libxslt/-/issues/144
    # Source: https://gitlab.gnome.org/GNOME/libxslt/-/merge_requests/77
    ./77-Use-a-dedicated-node-type-to-maintain-the-list-of-cached-rv-ts.patch

    # Fix type confusion in xmlNode.psvi between stylesheet and source nodes
    # https://gitlab.gnome.org/GNOME/libxslt/-/issues/139
    # Fix heap-use-after-free in xmlFreeID caused by `atype` corruption
    # https://gitlab.gnome.org/GNOME/libxslt/-/issues/140
    #
    # Depends on unmerged libxml2 patch that breaks ABI.
    #
    # Source: https://github.com/chromium/chromium/blob/4fb4ae8ce3daa399c3d8ca67f2dfb9deffcc7007/third_party/libxslt/chromium/new-unified-atype-extra.patch
    ./new-unified-atype-extra.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libxml2.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gettext
  ]
  ++ lib.optionals pythonSupport [
    libxml2.py
    python3
    ncurses
  ]
  ++ lib.optionals cryptoSupport [
    libgcrypt
  ];

  propagatedBuildInputs = [
    findXMLCatalogs
  ];

  configureFlags = [
    (lib.withFeature pythonSupport "python")
    (lib.optionalString pythonSupport "PYTHON=${python3.pythonOnBuildForHost.interpreter}")
    (lib.withFeature cryptoSupport "crypto")
  ];

  enableParallelBuilding = true;

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
  ''
  + lib.optionalString pythonSupport ''
    mkdir -p $py/nix-support
    echo ${libxml2.py} >> $py/nix-support/propagated-build-inputs
    moveToOutput ${python3.sitePackages} "$py"
  '';

  passthru = {
    inherit pythonSupport;

    updateScript = gnome.updateScript {
      packageName = "libxslt";
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/libxslt";
    description = "C library and tools to do XSL transformations";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jtojnar ];
    broken = pythonSupport && !libxml2.pythonSupport; # see #73102 for why this is not an assert
  };
})
