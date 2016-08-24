{ stdenv, fetchgit, which, perl, jdk
, ocamlPackages, openssl
, coreutils, zlib, ncurses, makeWrapper
, gcc, binutils, gnumake, nodejs} :

stdenv.mkDerivation rec {
  pname = "opa";
  version = "4309";
  name = "${pname}-${version}";

  src = fetchgit {
    url = https://github.com/MLstate/opalang.git;
    rev = "047f58bfd4be35ee30176156b3718c707a6c0f76";
    sha256 = "1laynwf64713q2vhdkxw679dah6hl3bvmrj8cj836a9k9z7jcc1r";
  };

  # Paths so the opa compiler code generation will use the same programs as were
  # used to build opa.
  codeGeneratorPaths = stdenv.lib.makeBinPath [ ocamlPackages.ocaml gcc binutils gnumake nodejs ];

  preConfigure = ''
    patchShebangs .
    (
    cat ./compiler/buildinfos/buildInfos.ml.pre
    ./compiler/buildinfos/generate_buildinfos.sh . --release --version ./compiler/buildinfos/version_major.txt 
    echo let opa_git_version = ${version}
    echo 'let opa_git_sha = "xxxx"'
    cat ./compiler/buildinfos/buildInfos.ml.post
    )> ./compiler/buildinfos/buildInfos.ml
  '';

  prefixKey = "-prefix ";

  configureFlags = "-ocamlfind ${ocamlPackages.findlib}/bin/ocamlfind ";

  buildInputs = [ which perl jdk openssl coreutils zlib ncurses
    makeWrapper gcc binutils gnumake nodejs
  ] ++ (with ocamlPackages; [
    ocaml findlib ocaml_ssl cryptokit camlzip ulex ocamlgraph
  ]);

  NIX_LDFLAGS = "-lgcc_s";

  postInstall = ''
    # Have compiler use same tools for code generation as used to build it.
    for p in $out/bin/opa ; do
      wrapProgram $p --prefix PATH ":" "${codeGeneratorPaths}" ;
    done

    # Install emacs mode.
    mkdir -p $out/share/emacs/site-lisp/opa
    install -m 0644 -v ./tools/editors/emacs/{opa-mode.el,site-start.el} $out/share/emacs/site-lisp/opa
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
    platforms = with stdenv.lib.platforms; linux;
  };
}
