{stdenv, fetchurl, ocaml, lablgtk, findlib, mesa, freeglut, camlp4 } :

let
  pname = "lablgl";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.05";

  src = fetchurl { 
    url = "http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/dist/lablgl-${version}.tar.gz";
    sha256 = "0qabydd219i4ak7hxgc67496qnnscpnydya2m4ijn3cpbgih7zyq";
  };

  buildInputs = [ocaml findlib lablgtk freeglut camlp4];
  propagatedBuildInputs = [ mesa ];

  patches = [ ./Makefile.config.patch ./META.patch ];

  preConfigure = ''
    substituteInPlace Makefile.config \
      --subst-var-by BINDIR $out/bin \
      --subst-var-by INSTALLDIR $out/lib/ocaml/${ocaml.version}/site-lib/lablgl \
      --subst-var-by DLLDIR $out/lib/ocaml/${ocaml.version}/site-lib/lablgl \
      --subst-var-by TKINCLUDES "" \
      --subst-var-by XINCLUDES ""
  '';

  createFindlibDestdir = true;

  buildFlags = "lib libopt glut glutopt";

  postInstall = ''
    cp ./META $out/lib/ocaml/${ocaml.version}/site-lib/lablgl
  '';

  meta = with stdenv.lib; {
    homepage = http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgl.html;
    description = "OpenGL bindings for ocaml";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub vbgl ];
    broken = stdenv.isDarwin;
  };
}
