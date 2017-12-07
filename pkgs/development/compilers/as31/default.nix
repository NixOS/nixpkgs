{ stdenv, fetchpatch, fetchurl, yacc }:

let

  version = "2.3.1";

in stdenv.mkDerivation {
  name = "as31-${version}";
  src = fetchurl {
    name = "as31-${version}.tar.gz"; # Nix doesn't like the colons in the URL
    url = "http://wiki.erazor-zone.de/_media/wiki:projects:linux:as31:as31-${version}.tar.gz";
    sha256 = "0mbk6z7z03xb0r0ccyzlgkjdjmdzknck4yxxmgr9k7v8f5c348fd";
  };

  buildInputs = [ yacc ];

  patches = [
    # CVE-2012-0808
    (fetchpatch {
       name = "as31-mkstemps.patch";
       url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=655496;filename=as31-mkstemps.patch;msg=5";
       sha256 = "0iia4wa8m141bwz4588yxb1dp2qwhapcii382sncm6jvwyngwh21";
     })
  ];

  preConfigure = ''
    chmod +x ./configure
  '';

  postConfigure = ''
    rm as31/parser.c
  '';

  meta = with stdenv.lib; {
    homepage = http://wiki.erazor-zone.de/wiki:projects:linux:as31;
    description = "An 8031/8051 assembler by Ken Stauffer and Theo Deraadt which produces a variety of object code output formats";
    maintainers = with maintainers; [ aneeshusa ];
    platforms = with platforms; unix;
  };
}
