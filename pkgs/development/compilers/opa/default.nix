{ stdenv, fetchurl, which, ocaml, perl, jdk
, findlib, ocaml_ssl, openssl, cryptokit, camlzip, ulex
, ocamlgraph, coreutils, zlib, ncurses, makeWrapper
, gcc, binutils, gnumake, nodejs, git } :

stdenv.mkDerivation rec {
  pname = "opa";
  version = "4308";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/MLstate/opalang/tarball/v${version}";
    name = "opa-${version}.tar.gz";
    sha256 = "1farii9474i14ack6bpqm1jihs6i8pvwky3a7q8v8pbnl4i6lb5g";
  };

  # Paths so the opa compiler code generation will use the same programs as were
  # used to build opa.
  codeGeneratorPaths = "${ocaml}/bin:${gcc}/bin:${binutils}/bin:${gnumake}/bin";

  prePatch = ''
    find . -type f -exec sed -i 's@/usr/bin/env@${coreutils}/bin/env@' {} \;
    find . -type f -exec sed -i 's@/usr/bin/perl@${perl}/bin/perl@' {} \;
  '';

  patches = [];

  preConfigure = ''
    configureFlags="$configureFlags -prefix $out"
    (
    cat ./compiler/buildinfos/buildInfos.ml.pre
    ./compiler/buildinfos/generate_buildinfos.sh . --release --version ./compiler/buildinfos/version_major.txt 
    echo let opa_git_version = ${version}
    echo 'let opa_git_sha = "xxxx"'
    cat ./compiler/buildinfos/buildInfos.ml.post
    )> ./compiler/buildinfos/buildInfos.ml
  '';

  dontAddPrefix = true;

  configureFlags = "-ocamlfind ${findlib}/bin/ocamlfind ";

  buildInputs = [ which ocaml perl jdk findlib ocaml_ssl openssl cryptokit camlzip ulex
                  ocamlgraph coreutils zlib ncurses makeWrapper gcc binutils gnumake
		  nodejs git
		  ];

  postInstall = ''
    # Have compiler use same tools for code generation as used to build it.
    for p in $out/bin/opa ; do
      wrapProgram $p --prefix PATH ":" "${codeGeneratorPaths}" ;
    done

    # Install emacs mode.
    mkdir -p $out/share/emacs/site-lisp/opa
    install -m 0644 -v ./utils/emacs/{opa-mode.el,site-start.el} $out/share/emacs/site-lisp/opa
  '';

  meta = {
    description = "A concise and elegant language for writing distributed web applications";
    longDescription = ''
      Opa is a new generation of web development platform that lets you write distributed
      web applications using a single technology. Among the the many features of Opa are these:
      Opa is concise, simple, concurrent, dynamically distributed, and secure.
    '';
    homepage = http://opalang.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.kkallio ];
    platforms = [ "x86_64-linux" ];
    # File "compiler/libqmlcompil/dbGen/schema_io.ml", line 199, characters 3-53:
    # Error: Signature mismatch:
    #        ...
    #     The field `remove_edge_e' is required but not provided
    #     The field `remove_edge' is required but not provided
    #     The field `remove_vertex' is required but not provided
    # Command exited with code 2.
    # make: *** [node] Error 10
    broken = true;
  };
}
