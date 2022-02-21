{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, libxml2
, findXMLCatalogs
, gettext
, python
, libgcrypt
, cryptoSupport ? false
, pythonSupport ? stdenv.buildPlatform == stdenv.hostPlatform
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libxslt";
  version = "1.1.34";

  outputs = [ "bin" "dev" "out" "man" "doc" ] ++ lib.optional pythonSupport "py";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "KMR9szq02u+mIy8xzLPGUmDIJRUeyG7EYTVSR/P1aCQ=";
  };

  patches = [
    (fetchpatch {
      # Fixes use-after-free in xsltApplyTemplates
      name = "CVE-2021-30560.patch";
      url = "https://gitlab.gnome.org/GNOME/libxslt/-/commit/50f9c9cd3b7dfe9b3c8c795247752d1fdcadcac8.patch";
      hash = "sha256-XJD9SBo8xzztQQ6g13h4IzID7HV7u3xWSQdb2rVCJBQ=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxml2.dev
  ] ++ lib.optional stdenv.isDarwin [
    gettext
  ] ++ lib.optionals pythonSupport [
    libxml2.py
    python
  ] ++ lib.optionals cryptoSupport [
    libgcrypt
  ];

  propagatedBuildInputs = [
    findXMLCatalogs
  ];

  configureFlags = [
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ] ++ lib.optionals pythonSupport [
    "--with-python=${python}"
  ] ++ lib.optionals (!cryptoSupport) [
    "--without-crypto"
  ];

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '' + lib.optionalString pythonSupport ''
    mkdir -p $py/nix-support
    echo ${libxml2.py} >> $py/nix-support/propagated-build-inputs
    moveToOutput ${python.libPrefix} "$py"
  '';

  passthru = {
    inherit pythonSupport;

    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "http://xmlsoft.org/XSLT/";
    description = "A C library and tools to do XSL transformations";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ eelco jtojnar ];
    broken = pythonSupport && !libxml2.pythonSupport; # see #73102 for why this is not an assert
  };
}
