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
, libxcrypt
, libgcrypt
, cryptoSupport ? false
, pythonSupport ? libxml2.pythonSupport
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libxslt";
  version = "1.1.38";

  outputs = [ "bin" "dev" "out" "doc" "devdoc" ] ++ lib.optional pythonSupport "py";
  outputMan = "bin";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "HzJFBCWBmgmsr/Krelp/ii7HlW5QXXvutF6EPQ4eyrE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libxml2.dev libxcrypt
  ] ++ lib.optionals stdenv.isDarwin [
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
    (lib.withFeature pythonSupport "python")
    (lib.optionalString pythonSupport "PYTHON=${python.pythonForBuild.interpreter}")
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
