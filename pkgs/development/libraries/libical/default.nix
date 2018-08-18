{ stdenv, fetchFromGitHub, perl, pkgconfig, cmake, ninja, vala, gobjectIntrospection
, python3, tzdata, gtk-doc, docbook_xsl, docbook_xml_dtd_43, glib, libxml2, icu }:

stdenv.mkDerivation rec {
  name = "libical-${version}";
  version = "3.0.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "libical";
    repo = "libical";
    rev = "v${version}";
    sha256 = "0dhlfn6n136di4fbqd74gdaibyh5zz1vac5x8ii3bjc2d5h7hw8h";
  };

  nativeBuildInputs = [
    perl pkgconfig cmake ninja vala gobjectIntrospection
    (python3.withPackages (pkgs: with pkgs; [ pygobject3 ])) # running libical-glib tests
    gtk-doc docbook_xsl docbook_xml_dtd_43 # docs
  ];
  buildInputs = [ glib libxml2 icu ];

  cmakeFlags = [
    "-DGOBJECT_INTROSPECTION=True"
    "-DICAL_GLIB_VAPI=True"
  ];

  patches = [
    # TODO: upstream this patch
    # https://github.com/libical/libical/issues/350
    ./respect-env-tzdir.patch
  ];

  # Using install check so we do not have to manually set
  # LD_LIBRARY_PATH and GI_TYPELIB_PATH variables
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export TZDIR=${tzdata}/share/zoneinfo
    ctest --output-on-failure

    runHook postInstallCheck
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/libical/libical;
    description = "An Open Source implementation of the iCalendar protocols";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
