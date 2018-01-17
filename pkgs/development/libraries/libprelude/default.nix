{ stdenv
, fetchurl
, pkgconfig
, bison
, flex
, gnutls
, lua
, perl
, python
, ruby
, swig
}:

let

in
stdenv.mkDerivation rec {
  name = "libprelude-${version}";
  version = "4.1.0";

  src = fetchurl {
    url = "https://www.prelude-siem.org/attachments/download/831/libprelude-4.1.0.tar.gz";
    sha256 = "0bana4wq4n64i90pxjljksi34yvvja8pib86qq1nj4y45zp5pvi1";
  };

  nativeBuildInputs = [
    bison
    flex
    pkgconfig
    swig
  ];

  buildInputs = [
    gnutls
  ];

  propagatedBuildInputs = [
    lua
    perl
    python
    ruby
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  installFlags = [
    "PRELUDE_SPOOL_DIR=\${TMPDIR}"
    "PRELUDE_CONFIG_DIR=\${out}/etc"
    "localstatedir=\${TMPDIR}"
    "sysconfdir=\${out}/etc"
  ];

  meta = with stdenv.lib; {
    homepage = https://www.prelude-siem.org/projects/libprelude;
    description = "IDMEF transport library used by all Prelude agents";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
