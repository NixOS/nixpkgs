{ stdenv, fetchurl, which, ocaml, perl, jdk
, findlib, ocaml_ssl, openssl, cryptokit, camlzip, ulex
, ocamlgraph, coreutils, zlib, ncurses, makeWrapper
, gcc, binutils, gnumake } :

stdenv.mkDerivation rec {
  pname = "opa";
  version = "962";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/MLstate/opalang/tarball/v${version}";
    name = "opa-${version}.tar.gz";
    sha256 = "0g4kq2kxbld0iqlzb076b7g43d8fh4sfxam615z15mbk1jcvpf9l";
  };

  # Paths so the opa compiler code generation will use the same programs as were
  # used to build opa.
  codeGeneratorPaths = "${ocaml}/bin:${gcc}/bin:${binutils}/bin:${gnumake}/bin";

  prePatch = ''
    find . -type f -exec sed -i 's@/usr/bin/env@${coreutils}/bin/env@' {} \;
    find . -type f -exec sed -i 's@/usr/bin/perl@${perl}/bin/perl@' {} \;
  '';

  patches = [ ./locate.patch ./libdir.patch ];

  preConfigure = ''
    configureFlags="$configureFlags -prefix $out"
  '';

  dontAddPrefix = true;

  configureFlags = "-ocamlfind ${findlib}/bin/ocamlfind -openssl ${openssl}/lib";

  buildInputs = [ which ocaml perl jdk findlib ocaml_ssl openssl cryptokit camlzip ulex
                  ocamlgraph coreutils zlib ncurses makeWrapper gcc binutils gnumake ];

  postInstall = ''
    # Have compiler use same tools for code generation as used to build it.
    for p in $out/bin/opa ; do
      wrapProgram $p --prefix PATH ":" "${codeGeneratorPaths}" ;
    done

    # Install emacs mode.
    ensureDir $out/share/emacs/site-lisp/opa
    install -m 0644 -v ./utils/emacs/{opa-mode.el,site-start.el} $out/share/emacs/site-lisp/opa
  '';

  meta = {
    description = "Opa is a concise and elegant language for writing distributed web applications. Both client and server sides.";
    longDescription = ''
    Opa is a new generation of web development platform that lets you write distributed
    web applications using a single technology. Among the the many features of Opa are these:
    Opa is concise, simple, concurrent, dynamically distributed, and secure.
    '';

    homepage = http://opalang.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.kkallio ];
    platforms = [ "x86_64-linux" ];
  };
}
