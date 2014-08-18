{stdenv, fetchurl, ocaml, lablgtk, findlib, mesa, freeglut } :

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "lablgl";
  version = "1.04-1";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl { 
    url = "http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/dist/lablgl-20120306.tar.gz";
    sha256 = "1w5di2n38h7fkrf668zphnramygwl7ybjhrmww3pi9jcf9apa09r";
  };

  buildInputs = [ocaml findlib lablgtk mesa freeglut ];

  patches = [ ./Makefile.config.patch ];

  preConfigure = ''
    substituteInPlace Makefile.config \
      --subst-var-by BINDIR $out/bin \
      --subst-var-by INSTALLDIR $out/lib/ocaml/${ocaml_version}/site-lib/lablgl \
      --subst-var-by DLLDIR $out/lib/ocaml/${ocaml_version}/site-lib/lablgl/stublibs \
      --subst-var-by TKINCLUDES "" \
      --subst-var-by XINCLUDES ""
  '';

  createFindlibDestdir = true;

  #makeFlags = "BINDIR=$(out)/bin  MANDIR=$(out)/usr/share/man/man1 DYPGENLIBDIR=$(out)/lib/ocaml/${ocaml_version}/site-lib";
  buildFlags = "lib libopt glut glutopt";

  postInstall = ''
    cp ./META $out/lib/ocaml/${ocaml_version}/site-lib/lablgl
  '';

  meta = {
    homepage = http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgl.html;
    description = "OpenGL bindings for ocaml";
    license = "GnuGPLV2";
#    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
