{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ustr-${version}";
  version = "1.0.4";

  src = fetchurl {
    url = "http://www.and.org/ustr/${version}/${name}.tar.bz2";
    sha256 = "1i623ygdj7rkizj7985q9d6vj5amwg686aqb5j3ixpkqkyp6xbrx";
  };

  # Fixes bogus warnings that failed libsemanage
  patches = [ ./va_args.patch ];

  # Work around gcc5 switch to gnu11
  NIX_CFLAGS_COMPILE = "-std=gnu89";

  # Fix detection of stdint.h
  postPatch = ''
    sed -i 's,\(have_stdint_h\)=0,\1=1,g' Makefile
    sed -i 's,\(USTR_CONF_HAVE_STDINT_H\) 0,\1 1,g' ustr-import.in
  '';

  buildTargets = [ "all-shared" ];

  preBuild = ''
    makeFlagsArray+=("prefix=$out")
    makeFlagsArray+=("LDCONFIG=echo")
    makeFlagsArray+=("HIDE=")
  '';

  # Remove debug libraries
  postInstall = ''
    find $out/lib -name \*debug\* -delete
  '';

  meta = with stdenv.lib; {
    homepage = http://www.and.org/ustr/;
    description = "Micro String API for C language";
    license = licenses.bsd2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}
