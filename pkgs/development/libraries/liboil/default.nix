{stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "liboil-0.3.17";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "0sgwic99hxlb1av8cm0albzh8myb7r3lpcwxfm606l0bkc3h4pqh";
  };

  buildInputs = [ pkgconfig ];

  patches = [ ./x86_64-cpuid.patch ];

  # fix "argb_paint_i386.c:53:Incorrect register `%rax' used with `l' suffix"
  # errors
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--build=x86_64";

  meta = with stdenv.lib; {
    description = "A library of simple functions that are optimized for various CPUs";
    homepage    = http://liboil.freedesktop.org;
    license     = licenses.bsd2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.all;
  };
}
