{ stdenv, fetchurl, python, pkgconfig, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42, fixDarwinDylibNames
, wafHook
}:

stdenv.mkDerivation rec {
  name = "talloc-2.1.14";

  src = fetchurl {
    url = "mirror://samba/talloc/${name}.tar.gz";
    sha256 = "1kk76dyav41ip7ddbbf04yfydb4jvywzi2ps0z2vla56aqkn11di";
  };

  nativeBuildInputs = [ pkgconfig fixDarwinDylibNames python wafHook
                        docbook_xsl docbook_xml_dtd_42 ];
  buildInputs = [ readline libxslt ];

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--enable-talloc-compat1"
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  # this must not be exported before the ConfigurePhase otherwise waf whines
  preBuild = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    export NIX_CFLAGS_LINK="-no-pie -shared";
  '';

  postInstall = ''
    ${stdenv.cc.targetPrefix}ar q $out/lib/libtalloc.a bin/default/talloc_[0-9]*.o
  '';

  meta = with stdenv.lib; {
    description = "Hierarchical pool based memory allocator with destructors";
    homepage = https://tdb.samba.org/;
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
