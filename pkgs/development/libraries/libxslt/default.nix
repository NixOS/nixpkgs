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
  version = "1.1.35";

  outputs = [ "bin" "dev" "out" "man" "doc" ] ++ lib.optional pythonSupport "py";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "gkfzPpqHLGrIWapFAYvExNALl+L+rJ7rwQyTzh803Xk=";
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
    homepage = "https://gitlab.gnome.org/GNOME/libxslt";
    description = "A C library and tools to do XSL transformations";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ eelco jtojnar ];
    broken = pythonSupport && !libxml2.pythonSupport; # see #73102 for why this is not an assert
  };
}
