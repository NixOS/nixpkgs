{ lib, stdenv, fetchFromGitHub, which, perl, jdk
, ocamlPackages, openssl
, coreutils, zlib, ncurses, makeWrapper
, gcc, binutils, gnumake, nodejs
}:

stdenv.mkDerivation rec {
  pname = "opa";
  version = "4310";

  src = fetchFromGitHub {
    owner = "MLstate";
    repo = "opalang";
    rev = "a13d45af30bc955c40c4b320353fb21e4ecacbc5";
    sha256 = "1qs91rq9xrafv2mf2v415k8lv91ab3ycz0xkpjh1mng5ca3pjlf3";
  };

  patches = [ ./ocaml-4.03.patch ./ocaml-4.04.patch ];

  # Paths so the opa compiler code generation will use the same programs as were
  # used to build opa.
  codeGeneratorPaths = lib.makeBinPath [ ocamlPackages.ocaml gcc binutils gnumake nodejs ];

  preConfigure = ''
    patchShebangs .
    (
    cat ./compiler/buildinfos/buildInfos.ml.pre
    ./compiler/buildinfos/generate_buildinfos.sh . --release --version ./compiler/buildinfos/version_major.txt
    echo let opa_git_version = ${version}
    echo 'let opa_git_sha = "xxxx"'
    cat ./compiler/buildinfos/buildInfos.ml.post
    )> ./compiler/buildinfos/buildInfos.ml
    for p in configure tools/platform_helper.sh
    do
      substituteInPlace $p --replace 'IS_MAC=1' 'IS_LINUX=1'
    done
    export CAMLP4O=${ocamlPackages.camlp4}/bin/camlp4o
    export CAMLP4ORF=${ocamlPackages.camlp4}/bin/camlp4orf
    export OCAMLBUILD=${ocamlPackages.ocamlbuild}/bin/ocamlbuild
    substituteInPlace _tags --replace ', warn_error_A' ""
  '';

  prefixKey = "-prefix ";

  configureFlags = [ "-ocamlfind ${ocamlPackages.findlib}/bin/ocamlfind" ];

  buildInputs = [ which perl jdk openssl coreutils zlib ncurses
    makeWrapper gcc binutils gnumake nodejs
  ] ++ (with ocamlPackages; [
    ocaml findlib ssl cryptokit camlzip ulex ocamlgraph camlp4
  ]);

  NIX_LDFLAGS = lib.optionalString (!stdenv.isDarwin) "-lgcc_s";

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
    homepage = "http://opalang.org/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.kkallio ];
    platforms = with lib.platforms; unix;
  };
}
