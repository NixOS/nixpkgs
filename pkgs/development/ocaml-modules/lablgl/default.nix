{ lib, stdenv, fetchFromGitHub, ocaml, findlib, libGLU, libGL, freeglut } :

if lib.versionOlder ocaml.version "4.03"
then throw "lablgl is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-lablgl";
  version = "1.06";

  src = fetchFromGitHub {
    owner = "garrigue";
    repo = "lablgl";
    rev = "v${version}";
    sha256 = "sha256:141kc816iv59z96738i3vn9m9iw9g2zhi45hk4cchpwd99ar5l6k";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocaml findlib ];
  buildInputs = [ freeglut ];
  propagatedBuildInputs = [ libGLU libGL ];

  patches = [ ./Makefile.config.patch ./META.patch ];

  preConfigure = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
    substituteInPlace Makefile.config \
      --subst-var-by BINDIR $out/bin/ \
      --subst-var-by INSTALLDIR $out/lib/ocaml/${ocaml.version}/site-lib/lablgl/ \
      --subst-var-by DLLDIR $out/lib/ocaml/${ocaml.version}/site-lib/stublibs/ \
      --subst-var-by TKINCLUDES "" \
      --subst-var-by XINCLUDES ""
  '';

  buildFlags = [ "lib" "libopt" "glut" "glutopt" ];

  postInstall = ''
    cp ./META $out/lib/ocaml/${ocaml.version}/site-lib/lablgl
  '';

  meta = with lib; {
    description = "OpenGL bindings for ocaml";
    homepage = "http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgl.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub vbgl ];
    mainProgram = "lablglut";
    broken = stdenv.isDarwin;
  };
}
