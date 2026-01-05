{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  ocaml_oasis,
  bitstring,
  camlzip,
  cmdliner,
  core_kernel,
  ezjsonm,
  fileutils,
  jane_rope ? null,
  mmap,
  lwt,
  ocamlgraph,
  ocurl,
  re,
  uri,
  zarith,
  piqi,
  piqi-ocaml,
  uuidm,
  llvm,
  frontc,
  ounit,
  ppx_jane,
  parsexp ? null,
  utop,
  libxml2,
  ncurses,
  linenoise,
  ppx_bap,
  ppx_bitstring,
  yojson,
  which,
  makeWrapper,
  writeText,
  z3,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-bap";
  version = "2.5.0+pr1621";
  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap";
    rev = "65c282d94e8b7028e8a986c637db3a2378a753f6";
    hash = "sha256-LUZZOgG1T8xa5jLA/fDft8ofYb/Yf6QjTrl6AlLY7H0=";
  };

  sigs = fetchurl {
    url = "https://github.com/BinaryAnalysisPlatform/bap/releases/download/v${version}/sigs.zip";
    sha256 = "0d69jd28z4g64mglq94kj5imhmk5f6sgcsh9q2nij3b0arpcliwk";
  };

  createFindlibDestdir = true;

  setupHook = writeText "setupHook.sh" ''
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/ocaml${ocaml.version}-bap-${version}/"
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/ocaml${ocaml.version}-bap-${version}-llvm-plugins/"
  '';

  nativeBuildInputs = [
    which
    makeWrapper
    ocaml
    findlib
    ocamlbuild
    ocaml_oasis
  ];

  buildInputs = [
    ocamlbuild
    linenoise
    ounit
    ppx_bitstring
    z3
    utop
    libxml2
    ncurses
  ];

  propagatedBuildInputs = [
    bitstring
    camlzip
    cmdliner
    ppx_bap
    core_kernel
    ezjsonm
    fileutils
    jane_rope
    mmap
    lwt
    ocamlgraph
    ocurl
    re
    uri
    zarith
    piqi
    parsexp
    piqi-ocaml
    uuidm
    frontc
    yojson
  ];

  installPhase = ''
    runHook preInstall
    export OCAMLPATH=$OCAMLPATH:$OCAMLFIND_DESTDIR;
    export PATH=$PATH:$out/bin
    export CAML_LD_LIBRARY_PATH=''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}$OCAMLFIND_DESTDIR/bap-plugin-llvm/:$OCAMLFIND_DESTDIR/bap/
    mkdir -p $out/lib/bap
    make install
    rm $out/bin/baptop
    makeWrapper ${utop}/bin/utop $out/bin/baptop --prefix OCAMLPATH : $OCAMLPATH --prefix PATH : $PATH --add-flags "-ppx ppx-bap -short-paths -require \"bap.top\""
    wrapProgram $out/bin/bapbuild --prefix OCAMLPATH : $OCAMLPATH --prefix PATH : $PATH
    ln -s $sigs $out/share/bap/sigs.zip
    runHook postInstall
  '';

  disableIda = "--disable-ida";
  disableGhidra = "--disable-ghidra";

  patches = [
    ./curses_is_ncurses.patch
  ];

  preConfigure = ''
    substituteInPlace oasis/monads --replace-warn core_kernel.rope jane_rope
  '';

  configureFlags = [
    "--enable-everything ${disableIda} ${disableGhidra}"
    "--with-llvm-config=${llvm.dev}/bin/llvm-config"
  ];

  meta = with lib; {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages";
    homepage = "https://github.com/BinaryAnalysisPlatform/bap/";
    license = licenses.mit;
    maintainers = [ maintainers.maurer ];
    mainProgram = "bap";
    broken = lib.versionOlder ocaml.version "4.08";
  };
}
