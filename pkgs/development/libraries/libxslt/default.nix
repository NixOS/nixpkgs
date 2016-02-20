{ stdenv, fetchurl, fetchpatch, libxml2, findXMLCatalogs }:

stdenv.mkDerivation rec {
  name = "libxslt-1.1.28";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "13029baw9kkyjgr7q3jccw2mz38amq7mmpr5p3bh775qawd1bisz";
  };

  patches = stdenv.lib.optional stdenv.isSunOS ./patch-ah.patch
    ++ [
      (fetchpatch {
        name = "CVE-2015-7995.patch";
        url = "http://git.gnome.org/browse/libxslt/patch/?id=7ca19df892ca22";
        sha256 = "1xzg0q94dzbih9nvqp7g9ihz0a3qb0w23l1158m360z9smbi8zbd";
      })
    ];

  outputs = [ "out" "doc" ];

  buildInputs = [ libxml2 ];

  propagatedBuildInputs = [ findXMLCatalogs ];

  configureFlags = [
    "--with-libxml-prefix=${libxml2}"
    "--without-python"
    "--without-crypto"
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ];

  meta = {
    homepage = http://xmlsoft.org/XSLT/;
    description = "A C library and tools to do XSL transformations";
    license = "bsd";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
