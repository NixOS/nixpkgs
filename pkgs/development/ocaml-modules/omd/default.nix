{stdenv, xenserver-buildroot, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-omd-1.0.2";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/ocaml/omd/archive/1.0.2/ocaml-omd-1.0.2.tar.gz";
    sha256 = "0mc1ni2rm4ypxhxh237xyj6zn0n8lws9bjyswzwill5vr6xq6d62";
  };

  patches = [ "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-omd-setup.ml.patch" ];

  buildInputs = [ ocaml findlib ];

  configurePhase = ''
    ocaml setup.ml -configure --prefix $out \
          --destdir $out
    '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install
    cp -r $out/$out/bin $out/bin
    rm -r $out/nix
    '';

  meta = {
    homepage = https://github.com/ocaml/omd;
    description = "A Markdown frontend in pure OCaml.";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
