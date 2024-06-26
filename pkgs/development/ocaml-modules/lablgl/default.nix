{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  libGLU,
  libGL,
  freeglut,
  camlp-streams,
  darwin,
}:

if lib.versionOlder ocaml.version "4.06" then
  throw "lablgl is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation rec {
    pname = "ocaml${ocaml.version}-lablgl";
    version = "1.07";

    src = fetchFromGitHub {
      owner = "garrigue";
      repo = "lablgl";
      rev = "v${version}";
      hash = "sha256-GiQKHMn5zHyvDrA2ve12X5YTm3/RZp8tukIqifgVaW4=";
    };

    strictDeps = true;

    nativeBuildInputs = [
      ocaml
      findlib
    ];
    buildInputs = [
      freeglut
      camlp-streams
    ];
    propagatedBuildInputs =
      [
        libGLU
        libGL
      ]
      ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.GLUT
        darwin.apple_sdk.libs.Xplugin
      ];

    patches = [
      ./Makefile.config.patch
      ./META.patch
    ];

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

    buildFlags = [
      "lib"
      "libopt"
      "glut"
      "glutopt"
    ];

    postInstall = ''
      cp ./META $out/lib/ocaml/${ocaml.version}/site-lib/lablgl
    '';

    meta = with lib; {
      description = "OpenGL bindings for ocaml";
      homepage = "http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgl.html";
      license = licenses.gpl2;
      maintainers = with maintainers; [
        pSub
        vbgl
      ];
      mainProgram = "lablglut";
    };
  }
