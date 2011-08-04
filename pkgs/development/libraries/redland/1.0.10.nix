{ stdenv, fetchurl, pkgconfig, openssl, libxslt, perl
, curl, pcre, libxml2, librdf_rasqal, librdf_raptor
, mysql ? null, postgresql ? null, sqlite ? null, bdb ? null
}:

stdenv.mkDerivation rec {
  name = "redland-1.0.10";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "05cq722qvw5sq08qbydzjv5snqk402cbdsy8s6qjzir7vq2hs1p3";
  };

  buildInputs =
    [ pkgconfig bdb openssl libxslt perl mysql postgresql sqlite curl
      pcre libxml2
    ];

  propagatedBuildInputs = [ librdf_raptor librdf_rasqal ];

  preConfigure =
    ''
      export NIX_LDFLAGS="$NIX_LDFLAGS -lrasqal -lraptor"
    '';
  
  postInstall = "rm -rf $out/share/gtk-doc";
  
  configureFlags =
    [ "--with-threads" ]
    ++ stdenv.lib.optional (bdb != null) "--with-bdb=${bdb}";

  meta = {
    homepage = http://librdf.org/;
  };
}
