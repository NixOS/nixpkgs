{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "utf8proc-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/JuliaLang/utf8proc/archive/v${version}.tar.gz";
    sha256 = "0q1jhdkk4f9b0zb8s2ql3sba3br5nvjsmbsaybmgj064k9hwbk15";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A clean C library for processing UTF-8 Unicode data";
    homepage = https://julialang.org/utf8proc;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.ftrvxmtrx ];
  };
}
