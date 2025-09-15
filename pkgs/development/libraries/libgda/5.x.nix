{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  itstool,
  libxml2,
  gtk3,
  openssl,
  gnome,
  gobject-introspection,
  vala,
  libgee,
  fetchpatch,
  autoreconfHook,
  gtk-doc,
  autoconf-archive,
  yelp-tools,
  mysqlSupport ? false,
  libmysqlclient,
  postgresSupport ? false,
  libpq,
}:

stdenv.mkDerivation rec {
  pname = "libgda";
  version = "5.2.10";

  src = fetchurl {
    url = "mirror://gnome/sources/libgda/${lib.versions.majorMinor version}/libgda-${version}.tar.xz";
    hash = "sha256-b2zfe4BT9VO5B+DIimBk60jPJ1GFLrJDI9zwJ3kjNMg=";
  };

  patches = [
    # fix compile error with mysql
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libgda/-/commit/9859479884fad5f39e6c37e8995e57c28b11b1b9.diff";
      hash = "sha256-G2PS8LkUXj7deofEn8lgpEMbYg4RLB5injS9VRizGpU=";
    })
    (fetchpatch {
      name = "CVE-2021-39359.patch";
      url = "https://src.fedoraproject.org/rpms/libgda5/raw/72bb769f12e861e27e883dac5fab34f1ba4bd97e/f/bebdffb4de586fb43fd07ac549121f4b22f6812d.patch";
      hash = "sha256-hIKuY5NEqOzntdlLb541bA4xZU5ypTRmV1u765K6KbM=";
    })

    # Fix configure detection of features with c99.
    ./0001-gcc14-fix.patch
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    itstool
    gobject-introspection
    vala
    autoreconfHook
    gtk-doc
    autoconf-archive
    yelp-tools
    libpq.pg_config
  ];

  buildInputs = [
    gtk3
    openssl
    libgee
  ]
  ++ lib.optionals mysqlSupport [
    libmysqlclient
  ]
  ++ lib.optionals postgresSupport [
    libpq
  ];

  propagatedBuildInputs = [
    libxml2
  ];

  configureFlags = [
    "--with-mysql=${lib.boolToYesNo mysqlSupport}"
    "--with-postgres=${lib.boolToYesNo postgresSupport}"

    # macOS builds use the sqlite source code that comes with libgda,
    # as opposed to using the system or brewed sqlite3, which is not supported on macOS,
    # as mentioned in https://github.com/GNOME/libgda/blob/95eeca4b0470f347c645a27f714c62aa6e59f820/libgda/sqlite/README#L31,
    # which references the paper https://web.archive.org/web/20100610151539/http://lattice.umiacs.umd.edu/files/functions_tr.pdf
    # See also https://github.com/Homebrew/homebrew-core/blob/104f9ecd02854a82372b64d63d41356555378a52/Formula/libgda.rb
    "--enable-system-sqlite=${lib.boolToYesNo (!stdenv.hostPlatform.isDarwin)}"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libgda";
      attrPath = "libgda5";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = {
    description = "Database access library";
    homepage = "https://www.gnome-db.org/";
    license = with lib.licenses; [
      # library
      lgpl2Plus
      # CLI tools
      gpl2Plus
    ];
    maintainers = [ lib.maintainers.bot-wxt1221 ];
    platforms = lib.platforms.unix;
  };
}
