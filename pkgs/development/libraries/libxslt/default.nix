{ lib
, stdenv
, fetchurl
, pkg-config
, autoreconfHook
, libxml2
, findXMLCatalogs
, gettext
, python
, ncurses
, libgcrypt
, cryptoSupport ? false
, pythonSupport ? stdenv.buildPlatform == stdenv.hostPlatform
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libxslt";
  version = "1.1.36";

  outputs = [ "bin" "dev" "out" "doc" "devdoc" ] ++ lib.optional pythonSupport "py";
  outputMan = "bin";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "EoSPCkQI9ltTDTlizZ/2cLaueWGRz+/zdSK1dy3o3I4=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libxml2.dev
  ] ++ lib.optional stdenv.isDarwin [
    gettext
  ] ++ lib.optionals pythonSupport [
    libxml2.py
    python
    ncurses
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
  '' + lib.optionalString pythonSupport ''
    mkdir -p $py/nix-support
    echo ${libxml2.py} >> $py/nix-support/propagated-build-inputs
    moveToOutput ${python.sitePackages} "$py"
  '';

  passthru = {
    inherit pythonSupport;

    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/libxslt";
    description = "A C library and tools to do XSL transformations";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ eelco jtojnar ];
    broken = pythonSupport && !libxml2.pythonSupport; # see #73102 for why this is not an assert
  };
}
