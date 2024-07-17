{
  mkDerivation,
  lib,
  stdenv,
  fetchpatch,
  extra-cmake-modules,
  docbook_xml_dtd_45,
  docbook_xsl_ns,
  karchive,
  ki18n,
  qtbase,
  perl,
  perlPackages,
}:

mkDerivation {
  pname = "kdoctools";
  nativeBuildInputs = [
    extra-cmake-modules
    # The build system insists on having native Perl.
    perl
    perlPackages.URI
  ];
  propagatedBuildInputs = [
    # kdoctools at runtime actually needs Perl for the platform kdoctools is
    # running on, not necessarily native perl.
    perl
    perlPackages.URI
    qtbase
  ];
  buildInputs = [
    karchive
    ki18n
  ];
  outputs = [
    "out"
    "dev"
  ];
  patches =
    [ ./kdoctools-no-find-docbook-xml.patch ]
    # kf.doctools.core: Error: Could not find kdoctools catalogs
    ++ lib.optionals stdenv.isDarwin [
      (fetchpatch {
        name = "kdoctools-relocate-datapath.patch";
        url = "https://github.com/msys2/MINGW-packages/raw/0900785a1f4e4146ab9561fb92a1c70fa70fcfc4/mingw-w64-kdoctools-qt5/0001-kdoctools-relocate-datapath.patch";
        hash = "sha256-MlokdrabXavWHGXYmdz9zZDJQIwAdNxebJBSAH2Z3vI=";
      })
    ];
  cmakeFlags = [
    "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/xml/dtd/docbook"
    "-DDocBookXSL_DIR=${docbook_xsl_ns}/xml/xsl/docbook"
  ];
  postFixup = ''
    moveToOutput "share/doc" "$dev"
    moveToOutput "share/man" "$dev"
  '';
}
