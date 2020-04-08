{ stdenv
, fetchFromGitHub
, cmake
, glib
, gobject-introspection
, icu
, libxml2
, ninja
, perl
, pkgconfig
, python3
, tzdata
, vala
}:

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
    gobject-introspection
    ninja
    perl
    pkgconfig
    vala
    # Docs building fails:
    # https://github.com/NixOS/nixpkgs/pull/67204
    # previously with https://github.com/NixOS/nixpkgs/pull/61657#issuecomment-495579489
    # gtk-doc docbook_xsl docbook_xml_dtd_43 # for docs
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
    "-DGOBJECT_INTROSPECTION=True"
    "-DENABLE_GTK_DOC=False"
    "-DICAL_GLIB_VAPI=True"
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/libical/libical";
    description = "An Open Source implementation of the iCalendar protocols";
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
