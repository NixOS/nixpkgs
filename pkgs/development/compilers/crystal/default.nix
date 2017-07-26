{ stdenv, fetchurl, boehmgc, libatomic_ops, pcre, libevent, libiconv, llvm_4, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.23.0";
  name = "crystal-${version}-1";
  arch =
    {
      "x86_64-linux" = "linux-x86_64";
      "i686-linux" = "linux-i686";
      "x86_64-darwin" = "darwin-x86_64";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  prebuiltBinary = fetchurl {
    url = "https://github.com/crystal-lang/crystal/releases/download/${version}/crystal-${version}-1-${arch}.tar.gz";
    sha256 =
      {
        "x86_64-linux" = "0nhs7swbll8hrk15kmmywngkhij80x62axiskb1gjmiwvzhlh0qx";
        "i686-linux" = "03xp8d3lqflzzm26lpdn4yavj87qzgd6xyrqxp2pn9ybwrq8fx8a";
        "x86_64-darwin" = "1prz6c1gs8z7dgpdy2id2mjn1c8f5p2bf9b39985bav448njbyjz";
      }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");
  };

  src = fetchurl {
    url = "https://github.com/crystal-lang/crystal/archive/${version}.tar.gz";
    sha256 = "05ymwmjkl1b4m888p725kybpiap5ag2vj8l07d59j02inm5r0rcv";
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
    wrapProgram $(pwd)/crystal-${version}-1/embedded/bin/crystal \
        --suffix DYLD_LIBRARY_PATH : $libPath
  ''
  else ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      crystal-${version}-1/embedded/bin/crystal
    patchelf --set-rpath ${ stdenv.lib.makeLibraryPath [ stdenv.cc.cc ] } \
      crystal-${version}-1/embedded/bin/crystal
  '';

  buildPhase = ''
    # patch the script which launches the prebuilt compiler
    substituteInPlace $(pwd)/crystal-${version}-1/bin/crystal --replace \
      "/usr/bin/env bash" "${stdenv.shell}"
    substituteInPlace $(pwd)/crystal-${version}/bin/crystal --replace \
      "/usr/bin/env bash" "${stdenv.shell}"

    ${fixPrebuiltBinary}

    cd crystal-${version}
    make release=1 PATH="../crystal-${version}-1/bin:$PATH"
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
    homepage = "https://crystal-lang.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ mingchuan ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}

