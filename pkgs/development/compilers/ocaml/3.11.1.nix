args: with args;

let
   useX11 = (stdenv.system != "armv5tel-linux");
   useNativeCompilers = (stdenv.system != "armv5tel-linux");
   inherit (stdenv.lib) optionals optionalString;
in
stdenv.mkDerivation (rec {
  
  name = "ocaml-3.11.1";
  
  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-3.11/${name}.tar.bz2";
    sha256 = "8c36a28106d4b683a15c547dfe4cb757a53fa9247579d1cc25bd06a22cc62e50";
  };

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk"] ++ optionals useX11 [ "-x11lib" x11 ];
  buildFlags = "world" + optionalString useNativeCompilers " bootstrap world.opt";
  buildInputs = [ncurses] ++ optionals useX11 [ x11 ];
  installTargets = "install" + optionalString useNativeCompilers " installopt";
  patchPhase = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
  '';

  meta = {
    homepage = http://caml.inria.fr/ocaml;
    license = "QPL, LGPL2 (library part)";
    desctiption = "Most popular variant of the Caml language";
  };

})
