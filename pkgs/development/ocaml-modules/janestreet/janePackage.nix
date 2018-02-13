{ stdenv, fetchFromGitHub, ocaml, jbuilder, findlib, opam }:

{ name, version ? "0.9.0", buildInputs ? [], hash, meta, moveStubs ? null,
  ...}@args:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "${name}-${version} is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation (args // {
  name = "ocaml${ocaml.version}-${name}-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = name;
    rev = "v${version}";
    sha256 = hash;
  };

  buildInputs = [ ocaml jbuilder findlib ] ++ buildInputs;

  installPhase =
    let defaultMoveStubs = ''
    stubslibs="$out/lib/ocaml/${ocaml.version}/site-lib/stubslibs"
    if [ -d $stubslibs ]
    then
      for dll in $stubslibs/dll*.so
      do
        mv $dll $OCAMLFIND_DESTDIR/${name}
      done
    fi
    '';
    in
    ''
    ${opam}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR
    '' +
    args.moveStubs or defaultMoveStubs;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
    homepage = "https://github.com/janestreet/${name}";
  } // meta;
})
