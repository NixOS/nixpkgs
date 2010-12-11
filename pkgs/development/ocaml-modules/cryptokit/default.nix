{stdenv, fetchurl, zlib, ocaml}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.3";
in

stdenv.mkDerivation {
  name = "cryptokit-${version}";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/326/" +
          "cryptokit-${version}.tar.gz";
    sha256 = "0kqrlxkpzrj2qpniy6mhn7gx3n29s86vk4q0im2hqpxi9knkkwwy";
  };

  buildInputs = [zlib ocaml];

  patches = [ ./makefile.patch ];

  configurePhase = ''
    export INSTALLDIR="$out/lib/ocaml/${ocaml_version}/site-lib/cryptokit"
    substituteInPlace Makefile \
      --subst-var-by ZLIB_LIBDIR "${zlib}/lib" \
      --subst-var-by ZLIB_INCLUDE "${zlib}/include" \
      --subst-var INSTALLDIR 
  '';

  buildFlags = "all allopt";

  doCheck = true;
  
  checkTarget = "test";

  preInstall = "ensureDir $INSTALLDIR";

  postInstall = "cp -a ${./META} $INSTALLDIR/META";

  meta = {
    homepage = "http://pauillac.inria.fr/~xleroy/software.html";
    description = "A library of cryptographic primitives for OCaml";
  };
}
