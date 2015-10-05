{ stdenv, fetchurl, zlib, xz, python, findXMLCatalogs }:

let
  version = "2.9.2";
  inherit (stdenv.lib) optional;
in

stdenv.mkDerivation rec {
  name = "libxml2-${version}";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "1g6mf03xcabmk5ing1lwqmasr803616gb2xhn7pll10x2l5w6y2i";
  };

  outputs = [ "dev" "out" "bin" "doc" "py" ];
  propagatedOutputs = "out bin py";

  buildInputs = [ python ]
    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ optional stdenv.isFreeBSD xz;

  propagatedBuildInputs = [ zlib findXMLCatalogs ];

  configureFlags = "--with-python=${python}";

  enableParallelBuilding = true;

  preInstall = ''substituteInPlace python/libxml2mod.la --replace "${python}" "$py"'';
  installFlags = ''pythondir="$(py)/lib/${python.libPrefix}/site-packages"'';

  postFixup = ''
    _moveToOutput bin/xml2-config "$dev"
    _moveToOutput lib/xml2Conf.sh "$dev"
    _moveToOutput share/man/man1 "$bin"
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

