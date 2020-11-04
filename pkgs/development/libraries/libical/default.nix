{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, buildPackages
, cmake
, glib
, icu
, libxml2
, ninja
, perl
, pkgconfig
, libical
, python3
, tzdata
, introspectionSupport ? stdenv.buildPlatform == stdenv.hostPlatform
, gobject-introspection ? null
, vala ? null
}:

assert introspectionSupport -> gobject-introspection != null && vala != null;

stdenv.mkDerivation rec {
  pname = "libical";
  version = "3.0.8";

  outputs = [ "out" "dev" ]; # "devdoc" ];

  src = fetchFromGitHub {
    owner = "libical";
    repo = "libical";
    rev = "v${version}";
    sha256 = "0pkh74bfrgp1slv8wsv7lbmal2m7qkixwm5llpmfwaiv14njlp68";
  };

  nativeBuildInputs = [
    cmake
    ninja
    perl
    pkgconfig
    # Docs building fails:
    # https://github.com/NixOS/nixpkgs/pull/67204
    # previously with https://github.com/NixOS/nixpkgs/pull/61657#issuecomment-495579489
    # gtk-doc docbook_xsl docbook_xml_dtd_43 # for docs
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # provides ical-glib-src-generator that runs during build
    libical
  ] ++ lib.optionals introspectionSupport [
    gobject-introspection
    vala
  ];
  installCheckInputs = [
    # running libical-glib tests
    (python3.withPackages (pkgs: with pkgs; [
      pygobject3
    ]))
  ];

  buildInputs = [
    glib
    libxml2
    icu
  ];

  cmakeFlags = [
    "-DENABLE_GTK_DOC=False"
  ] ++ lib.optionals introspectionSupport [
    "-DGOBJECT_INTROSPECTION=True"
    "-DICAL_GLIB_VAPI=True"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DIMPORT_GLIB_SRC_GENERATOR=${lib.getDev buildPackages.libical}/lib/cmake/LibIcal/GlibSrcGenerator.cmake"
  ];

  patches = [
    # Will appear in 3.1.0
    # https://github.com/libical/libical/issues/350
    ./respect-env-tzdir.patch
    # Export src-generator binary for use while cross-compiling
    # https://github.com/libical/libical/pull/439
    (fetchpatch {
      url = "https://github.com/libical/libical/commit/1197d84b63dce179b55a6293cfd6d0523607baf1.patch";
      sha256 = "18i1khnwmw488s7g5a1kf05sladf8dbyhfc69mbcf6dkc4nnc3dg";
    })
  ];

  # Using install check so we do not have to manually set
  # LD_LIBRARY_PATH and GI_TYPELIB_PATH variables
  doInstallCheck = true;
  enableParallelChecking = false;
  installCheckPhase = ''
    runHook preInstallCheck

    export TZDIR=${tzdata}/share/zoneinfo
    ctest --output-on-failure --exclude-regex 'regression|recur|timezones|libical-glib-array|libical-glib-component|libical-glib-timezone'

    runHook postInstallCheck
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/libical/libical";
    description = "An Open Source implementation of the iCalendar protocols";
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
