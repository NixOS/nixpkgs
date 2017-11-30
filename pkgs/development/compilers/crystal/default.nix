{ stdenv, fetchurl, boehmgc, libatomic_ops, pcre, libevent, libiconv, llvm, makeWrapper }:

stdenv.mkDerivation rec {
  name = "crystal-${version}";
  version = "0.23.1";

  src = fetchurl {
    url = "https://github.com/crystal-lang/crystal/archive/${version}.tar.gz";
    sha256 = "8cf1b9a4eab29fca2f779ea186ae18f7ce444ce189c621925fa1a0c61dd5ff55";
  };

  prebuiltName = "crystal-0.23.0-1";
  prebuiltSrc = let arch = {
    "x86_64-linux" = "linux-x86_64";
    "i686-linux" = "linux-i686";
    "x86_64-darwin" = "darwin-x86_64";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");
  in fetchurl {
    url = "https://github.com/crystal-lang/crystal/releases/download/0.23.0/${prebuiltName}-${arch}.tar.gz";
    sha256 = {
      "x86_64-linux" = "0nhs7swbll8hrk15kmmywngkhij80x62axiskb1gjmiwvzhlh0qx";
      "i686-linux" = "03xp8d3lqflzzm26lpdn4yavj87qzgd6xyrqxp2pn9ybwrq8fx8a";
      "x86_64-darwin" = "1prz6c1gs8z7dgpdy2id2mjn1c8f5p2bf9b39985bav448njbyjz";
    }."${stdenv.system}";
  };

  srcs = [ src prebuiltSrc ];

  # crystal on Darwin needs libiconv to build
  libs = [
    boehmgc libatomic_ops pcre libevent
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv
  ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = libs ++ [ llvm ];

  libPath = stdenv.lib.makeLibraryPath libs;

  sourceRoot = "${name}";

  fixPrebuiltBinary = if stdenv.isDarwin then ''
    wrapProgram ../${prebuiltName}/embedded/bin/crystal \
        --suffix DYLD_LIBRARY_PATH : $libPath
  ''
  else ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      ../${prebuiltName}/embedded/bin/crystal
    patchelf --set-rpath ${ stdenv.lib.makeLibraryPath [ stdenv.cc.cc ] } \
      ../${prebuiltName}/embedded/bin/crystal
  '';

  preBuild = ''
    patchShebangs bin/crystal
    patchShebangs ../${prebuiltName}/bin/crystal
    ${fixPrebuiltBinary}
    export PATH="$(pwd)/../${prebuiltName}/bin:$PATH"
  '';

  makeFlags = [ "CRYSTAL_CONFIG_VERSION=${version}" "release=1" "all" "doc" ];

  installPhase = ''
    install -Dm755 .build/crystal $out/bin/crystal
    wrapProgram $out/bin/crystal \
        --suffix CRYSTAL_PATH : lib:$out/lib/crystal \
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

  enableParallelBuilding = true;

  meta = {
    description = "A compiled language with Ruby like syntax and type inference";
    homepage = https://crystal-lang.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ sifmelcara david50407 ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
