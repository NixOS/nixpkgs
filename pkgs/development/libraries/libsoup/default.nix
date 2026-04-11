{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  glib,
  libxml2,
  meson,
  ninja,
  pkg-config,
  gnome,
  libsysprof-capture,
  gobject-introspection,
  vala,
  libpsl,
  brotli,
  gnomeSupport ? true,
  sqlite,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "libsoup";
  version = "2.74.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/${lib.versions.majorMinor version}/libsoup-${version}.tar.xz";
    sha256 = "sha256-5Ld8Qc/EyMWgNfzcMgx7xs+3XvfFoDQVPfFBP6HZLxM=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-52530.patch";
      url = "https://gitlab.gnome.org/GNOME/libsoup/-/commit/04df03bc092ac20607f3e150936624d4f536e68b.patch";
      hash = "sha256-WRLiW2B/xxr3hW0nmeRNrXtZL44S0nTptPRdTqBV8Iw=";
    })
    (fetchpatch {
      name = "CVE-2024-52531_1.patch";
      url = "https://git.launchpad.net/ubuntu/+source/libsoup2.4/patch/?id=4ce2f2dc8ba0c458edce0f039a087fb3ac57787e";
      hash = "sha256-wg1qz8xHcnTiinBTF0ECMkrsD8W6M4IbiKGgbJ1gp9o=";
    })
    (fetchpatch {
      name = "CVE-2024-52531_2.patch";
      url = "https://git.launchpad.net/ubuntu/+source/libsoup2.4/patch/?id=5866d63aed3500700c5f1d2868ff689bb2ba8b82";
      hash = "sha256-e/VXtKX+agCw+ESGbgQ83NaVNbB3jLTxL7+VgNGbZ7U=";
    })
    (fetchpatch {
      name = "CVE-2024-52532_1.patch";
      url = "https://git.launchpad.net/ubuntu/+source/libsoup2.4/patch/?id=98e096a0d2142e3c63de2cca7d4023f9c52ed2c6";
      hash = "sha256-h7k+HpcKlsVYlAONxTOiupMhsMkf2v246ouxLejurcY=";
    })
    (fetchpatch {
      name = "CVE-2024-52532_2.patch";
      url = "https://git.launchpad.net/ubuntu/+source/libsoup2.4/patch/?id=030e72420e8271299c324273f393d92f6d4bb53e";
      hash = "sha256-0BEJpEKgjmKACf53lHMglxhmevKsSXR4ejEoTtr4wII=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
  ];

  buildInputs = [
    sqlite
    libpsl
    glib.out
    brotli
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libsysprof-capture
  ];

  propagatedBuildInputs = [
    glib
    libxml2
  ];

  mesonFlags = [
    "-Dtls_check=false" # glib-networking is a runtime dependency, not a compile-time dependency
    "-Dgssapi=disabled"
    "-Dvapi=${if withIntrospection then "enabled" else "disabled"}"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
    "-Dgnome=${lib.boolToString gnomeSupport}"
    "-Dntlm=disabled"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    "-Dsysprof=disabled"
  ];

  env.NIX_CFLAGS_COMPILE = "-lpthread";

  doCheck = false; # ERROR:../tests/socket-test.c:37:do_unconnected_socket_test: assertion failed (res == SOUP_STATUS_OK): (2 == 200)
  separateDebugInfo = true;

  postPatch = ''
    # fixes finding vapigen when cross-compiling
    # the commit is in 3.0.6
    # https://gitlab.gnome.org/GNOME/libsoup/-/commit/5280e936d0a76f94dbc5d8489cfbdc0a06343f65
    substituteInPlace meson.build \
      --replace "required: vapi_opt)" "required: vapi_opt, native: false)"

    patchShebangs libsoup/
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libsoup_2_4";
      packageName = "libsoup";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = {
    description = "HTTP client/server library for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libsoup";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [
      "libsoup-2.4"
      "libsoup-gnome-2.4"
    ];
    knownVulnerabilities = [
      ''
        libsoup 2 is EOL, with many known unfixed CVEs.
        The last release happened 2023-10-11,
        with few security backports since and no stable release.

        Vulnerabilities likely include (incomplete list):
        - CVE-2025-4948: https://gitlab.gnome.org/GNOME/libsoup/-/issues/449
        - CVE-2025-46421: https://gitlab.gnome.org/GNOME/libsoup/-/issues/439
        - CVE-2025-32914: https://gitlab.gnome.org/GNOME/libsoup/-/issues/436
        - CVE-2025-32913: https://gitlab.gnome.org/GNOME/libsoup/-/issues/435
        - CVE-2025-32912: https://gitlab.gnome.org/GNOME/libsoup/-/issues/434
        - CVE-2025-32911: https://gitlab.gnome.org/GNOME/libsoup/-/issues/433
        - CVE-2025-32910: https://gitlab.gnome.org/GNOME/libsoup/-/issues/432
        - CVE-2025-32909: https://gitlab.gnome.org/GNOME/libsoup/-/issues/431
        - CVE-2025-32907: https://gitlab.gnome.org/GNOME/libsoup/-/issues/428
        - CVE-2025-32053: https://gitlab.gnome.org/GNOME/libsoup/-/issues/426
        - CVE-2025-32052: https://gitlab.gnome.org/GNOME/libsoup/-/issues/425
        - CVE-2025-32050: https://gitlab.gnome.org/GNOME/libsoup/-/issues/424
        - CVE-2024-52531: https://gitlab.gnome.org/GNOME/libsoup/-/issues/423
        - CVE-2025-2784: https://gitlab.gnome.org/GNOME/libsoup/-/issues/422

        These vulnerabilities were fixed in libsoup 3,
        with the vulnerable code present in libsoup 2 versions.
      ''
    ];
  };
}
