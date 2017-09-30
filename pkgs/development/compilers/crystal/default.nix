{ stdenv, fetchurl, boehmgc, libatomic_ops, pcre, libevent, libiconv, llvm_4, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.23.1";
  patch = "3";
  name = "crystal-${version}-${patch}";
  arch =
    {
      "x86_64-linux" = "linux-x86_64";
      "i686-linux" = "linux-i686";
      "x86_64-darwin" = "darwin-x86_64";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  prebuiltBinary = fetchurl {
    url = "https://github.com/crystal-lang/crystal/releases/download/${version}/crystal-${version}-${patch}-${arch}.tar.gz";
    sha256 =
      {
        "x86_64-linux" = "6a84cc866838ffa5250e28c3ce1a918a93f89c06393fe8cfd4068fcbbc66f3ab";
        "i686-linux" = "268a39b8d37385ff60d113d4d9fc966472160faa1e3bbf7ae58860ab6678aceb";
        "x86_64-darwin" = "d3f964ebfc5cd48fad73ab2484ea2a00268812276293dd0f7e9c7d184c8aad8a";
      }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");
  };

  src = fetchurl {
    url = "https://github.com/crystal-lang/crystal/archive/${version}.tar.gz";
    sha256 = "8cf1b9a4eab29fca2f779ea186ae18f7ce444ce189c621925fa1a0c61dd5ff55";
  };

  # crystal on Darwin needs libiconv to build
  buildInputs = [
    boehmgc libatomic_ops pcre libevent llvm_4 makeWrapper
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv
  ];

  libPath = stdenv.lib.makeLibraryPath ([
    boehmgc libatomic_ops pcre libevent
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv
  ]);

  unpackPhase = ''
    tar zxf ${src}
    tar zxf ${prebuiltBinary}
  '';

  sourceRoot = ".";

  fixPrebuiltBinary = if stdenv.isDarwin then ''
    wrapProgram $(pwd)/crystal-${version}-${patch}/embedded/bin/crystal \
        --suffix DYLD_LIBRARY_PATH : $libPath
  ''
  else ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      crystal-${version}-${patch}/embedded/bin/crystal
    patchelf --set-rpath ${ stdenv.lib.makeLibraryPath [ stdenv.cc.cc ] } \
      crystal-${version}-${patch}/embedded/bin/crystal
  '';

  newline = "\n";

  buildPhase = ''
    # patch the script which launches the prebuilt compiler
    patchShebangs $(pwd)/crystal-${version}-${patch}/bin/crystal
    patchShebangs $(pwd)/crystal-${version}/bin/crystal
    # Due to https://github.com/crystal-lang/crystal/issues/4719,
    # when building Crystal with LLVM 4 with debug infos from prebuilt binary (w/ LLVM 3.8) will always be failed.
    # So we are going to build a LLVM 4 version without debug info,
    # and use it to build Crystal with debug info on LLVM 4.
    substituteInPlace $(pwd)/crystal-${version}/Makefile --replace \
      "release ?=" "no_debug ?= ##${newline}force_rebuild ?= ##${newline}release ?="
    substituteInPlace $(pwd)/crystal-${version}/Makefile --replace \
      "FLAGS := " "FLAGS := \$(if \$(no_debug),--no-debug )"
    substituteInPlace $(pwd)/crystal-${version}/Makefile --replace \
      "$(O)/crystal:" "\$(O)/crystal: \$(if \$(force_rebuild),../rebuild.tmp)"
    ${fixPrebuiltBinary}

    cd crystal-${version}
    # Build without debug infos on LLVM 4
    make release=1 no_debug=1 PATH="../crystal-${version}-${patch}/bin:$PATH"
    
    # Rebuild Crystal with debug infos from the binary we just built
    touch $(pwd)/../rebuild.tmp
    wrapProgram .build/crystal \
        --suffix LIBRARY_PATH : $libPath
    make release=1 force_rebuild=1
    make doc
  '';

  installPhase = ''
    install -Dm755 .build/crystal $out/bin/crystal
    wrapProgram $out/bin/crystal \
        --suffix CRYSTAL_PATH : $out/lib/crystal \
        --suffix LIBRARY_PATH : $libPath
    install -dm755 $out/lib/crystal
    cp -r src/* $out/lib/crystal/

    install -dm755 $out/share/doc/crystal/api
    cp -r doc/* $out/share/doc/crystal/api/
    cp -r samples $out/share/doc/crystal/

    install -Dm644 etc/completion.bash $out/share/bash-completion/completions/crystal
    install -Dm644 etc/completion.zsh $out/share/zsh/site-functions/_crystal

    install -Dm644 man/crystal.1 $out/share/man/man1/crystal.1

    install -Dm644 LICENSE $out/share/licenses/crystal/LICENSE
  '';

  dontStrip = true;

  meta = {
    description = "A compiled language with Ruby like syntax and type inference";
    homepage = https://crystal-lang.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ sifmelcara david50407 ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
