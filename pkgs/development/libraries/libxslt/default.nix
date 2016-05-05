{ stdenv, fetchurl, fetchpatch, libxml2, findXMLCatalogs }:

stdenv.mkDerivation rec {
  name = "libxslt-1.1.28";

  src = fetchurl {
    url = "http://xmlsoft.org/sources/${name}.tar.gz";
    sha256 = "13029baw9kkyjgr7q3jccw2mz38amq7mmpr5p3bh775qawd1bisz";
  };

  patches = stdenv.lib.optional stdenv.isSunOS ./patch-ah.patch
    ++ stdenv.lib.optional (stdenv.cross.libc or null == "msvcrt")
        (fetchpatch {
          name = "mingw.patch";
          url = "http://git.gnome.org/browse/libxslt/patch/?id=ab5810bf27cd63";
          sha256 = "0kkqq3fv2k3q86al38vp6zwxazpvp5kslcjnmrq4ax5cm2zvsjk3";
        })
    ++ [
      (fetchpatch {
        name = "CVE-2015-7995.patch";
        url = "http://git.gnome.org/browse/libxslt/patch/?id=7ca19df892ca22";
        sha256 = "1xzg0q94dzbih9nvqp7g9ihz0a3qb0w23l1158m360z9smbi8zbd";
      })
    ];

  outputs = [ "dev" "out" "bin" "doc" ];

  buildInputs = [ libxml2 ];

  propagatedBuildInputs = [ findXMLCatalogs ];

  configureFlags = [
    "--without-python"
    "--without-crypto"
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ];

  postFixup = ''
    moveToOutput bin/xslt-config "$dev"
    moveToOutput lib/xsltConf.sh "$dev"
    moveToOutput share/man/man1 "$bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://xmlsoft.org/XSLT/;
    description = "A C library and tools to do XSL transformations";
    license = "bsd";
    platforms = platforms.unix;
    maintainers = [ maintainers.eelco ];
  };
}
