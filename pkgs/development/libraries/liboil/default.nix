{stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "liboil-0.3.17";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "0sgwic99hxlb1av8cm0albzh8myb7r3lpcwxfm606l0bkc3h4pqh";
  };

  buildInputs = [ pkgconfig ];

  patches = [ ./x86_64-cpuid.patch ];

  meta = {
    homepage = http://liboil.freedesktop.org;
    description = "A library of simple functions that are optimized for various CPUs";
    license = "BSD-2";
  };
}
