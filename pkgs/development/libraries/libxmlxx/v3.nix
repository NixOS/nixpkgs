{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  glibmm,
  perl,
  gnome,
  meson,
  ninja,
  docbook5,
  docbook-xsl-ns,
  doxygen,
  libxslt,
  fop,
  dblatex,
  graphviz,

  withDocumentation ? false,
  withManual ? false, # Broken due to not being allowed to fetch file from web
  withPDF ? false,
  withExamples ? false,
}:

stdenv.mkDerivation rec {
  pname = "libxml++";
  version = "3.2.5";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/${lib.versions.majorMinor version}/libxml++-${version}.tar.xz";
    hash = "sha256-DJs4G1qD1rOrSwuGXXJW2rJ9V1mBtjvi+Fnty5TaWcc=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.lists.optionals withDocumentation [
    "doc"
    "devdoc"
  ];

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
  ]
  ++ lib.lists.optionals withDocumentation [
    perl
    doxygen
    libxslt
    graphviz
  ]
  ++ lib.lists.optionals withManual [
    docbook5
    docbook-xsl-ns
  ]
  ++ lib.lists.optional withPDF [
    fop
    dblatex
  ];

  buildInputs = [ glibmm ];

  propagatedBuildInputs = [ libxml2 ];

  mesonFlags = [
    (lib.mesonBool "maintainer-mode" false)
    (lib.mesonBool "build-documentation" withDocumentation)
    (lib.mesonBool "build-manual" withManual)
    (lib.mesonBool "build-pdf" withPDF)
    (lib.mesonBool "build-examples" withExamples)
    (lib.mesonBool "build-tests" doCheck)
  ];

  preBuild = lib.strings.optionalString withDocumentation ''
    doxygen -u docs/reference/Doxyfile
  '';

  postFixup = ''
    substituteInPlace $dev/lib/pkgconfig/libxml++-3.0.pc \
      --replace-fail 'docdir=''${datarootdir}' "docdir=$doc/share"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libxmlxx3";
      packageName = pname;
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  doCheck = true;

  meta = with lib; {
    homepage = "https://libxmlplusplus.sourceforge.net/";
    description = "C++ wrapper for the libxml2 XML parser library, version 3";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ willow ];
  };
}
