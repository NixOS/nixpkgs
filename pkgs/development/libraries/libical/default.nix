{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, cmake
, glib
, icu
, libxml2
, ninja
, perl
, pkg-config
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
  version = "3.0.9";

  outputs = [ "out" "dev" ]; # "devdoc" ];

  src = fetchFromGitHub {
    owner = "libical";
    repo = "libical";
    rev = "v${version}";
    sha256 = "sha256-efdiGktLGITaQ6VinnfYG52fMhO0Av+JKROt2kTvS1U=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    perl
    pkg-config
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
  ];

  # Using install check so we do not have to manually set
  # LD_LIBRARY_PATH and GI_TYPELIB_PATH variables
  doInstallCheck = true;
  enableParallelChecking = false;
  installCheckPhase = ''
    runHook preInstallCheck

    export TZDIR=${tzdata}/share/zoneinfo
    ctest --output-on-failure

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/libical/libical";
    description = "An Open Source implementation of the iCalendar protocols";
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
