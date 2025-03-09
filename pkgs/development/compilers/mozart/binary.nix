{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  boost,
  gmp,
  tcl-8_5,
  tk-8_5,
  emacs,
}:

let
  version = "2.0.0";

  binaries = {
    x86_64-linux = fetchurl {
      url = "mirror://sourceforge/project/mozart-oz/v${version}-alpha.0/mozart2-${version}-alpha.0+build.4105.5c06ced-x86_64-linux.tar.gz";
      sha256 = "0rsfrjimjxqbwprpzzlmydl3z3aiwg5qkb052jixdxjyad7gyh5z";
    };
  };
in

stdenv.mkDerivation {
  pname = "mozart-binary";
  inherit version;

  preferLocalBuild = true;

  src =
    binaries.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    boost
    gmp
    tcl-8_5
    tk-8_5
  ];

  TK_LIBRARY = "${tk-8_5}/lib/tk8.5";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir $out
    tar xvf $src -C $out --strip-components=1

    for exe in $out/bin/{ozemulator,ozwish} ; do
      patchelf --set-interpreter $(< $NIX_CC/nix-support/dynamic-linker) \
               --set-rpath $libPath \
               $exe
    done

    wrapProgram $out/bin/ozwish \
      --set OZHOME $out \
      --set TK_LIBRARY $TK_LIBRARY

    wrapProgram $out/bin/ozemulator --set OZHOME $out

    ${lib.optionalString (emacs != null) ''
      wrapProgram $out/bin/oz --suffix PATH ":" ${lib.makeBinPath [ emacs ]}
    ''}

    sed -i $out/share/applications/oz.desktop \
        -e "s,Exec=oz %u,Exec=$out/bin/oz %u,"

    gzip -9n $out/share/mozart/elisp"/"*.elc

    patchShebangs $out
  '';

  meta = with lib; {
    homepage = "http://www.mozart-oz.org/";
    description = "Multiplatform implementation of the Oz programming language";
    longDescription = ''
      The Mozart Programming System combines ongoing research in
      programming language design and implementation, constraint logic
      programming, distributed computing, and human-computer
      interfaces. Mozart implements the Oz language and provides both
      expressive power and advanced functionality.
    '';
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    platforms = attrNames binaries;
    hydraPlatforms = [ ];
  };
}
