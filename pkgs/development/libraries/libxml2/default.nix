{ stdenv, fetchurl, zlib, xz, python, findXMLCatalogs }:

stdenv.mkDerivation rec {
  name = "libxml2-${version}";
  version = "2.9.3";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "0bd17g6znn2r98gzpjppsqjg33iraky4px923j3k8kdl8qgy7sad";
  };

  outputs = [ "dev" "out" "bin" "doc" "py" ];
  propagatedBuildOutputs = "out bin py";

  buildInputs = [ python ]
    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ stdenv.lib.optional stdenv.isFreeBSD xz;

  propagatedBuildInputs = [ zlib findXMLCatalogs ];

  configureFlags = "--with-python=${python} --exec_prefix=$dev";

  enableParallelBuilding = true;

  preInstall = ''substituteInPlace python/libxml2mod.la --replace "${python}" "$py"'';
  installFlags = ''pythondir="$(py)/lib/${python.libPrefix}/site-packages"'';

  postFixup = ''
    moveToOutput bin/xml2-config "$dev"
    moveToOutput lib/xml2Conf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '';

  passthru = { inherit version; pythonSupport = true; };

  meta = {
    homepage = http://xmlsoft.org/;
    description = "An XML parsing library for C";
    license = "bsd";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
