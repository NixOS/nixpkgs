{ stdenv, fetchurl, makeWrapper
, boehmgc, libatomic_ops, pcre, libevent, libiconv, llvm, clang, which }:

stdenv.mkDerivation rec {
  name = "crystal-${version}";
  version = "0.26.0";

  src = fetchurl {
    url = "https://github.com/crystal-lang/crystal/archive/${version}.tar.gz";
    sha256 = "18vv47xvnf3hl5js5sk58wj2khqq36kcs851i3lgr0ji7m0g3379";
  };

  prebuiltName = "crystal-0.26.0-1";
  prebuiltSrc = let arch = {
    "x86_64-linux" = "linux-x86_64";
    "i686-linux" = "linux-i686";
    "x86_64-darwin" = "darwin-x86_64";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");
  in fetchurl {
    url = "https://github.com/crystal-lang/crystal/releases/download/0.26.0/${prebuiltName}-${arch}.tar.gz";
    sha256 = {
      "x86_64-linux" = "1xban102yiiwmlklxvn3xp3q546bp8hlxxpakayajkhhnpl6yv45";
      "i686-linux" = "1igspf1lrv7wpmz0pfrkbx8m1ykvnv4zhic53cav4nicppm2v0ic";
      "x86_64-darwin" = "0hzc65ccajr0yhmvi5vbdgbzbp1gbjy56da24ds3zwwkam1ddk0k";
    }."${stdenv.system}";
  };

  unpackPhase = ''
    mkdir ${prebuiltName}
    tar --strip-components=1 -C ${prebuiltName} -xf ${prebuiltSrc}
    tar xf ${src}
  '';

  # crystal on Darwin needs libiconv to build
  libs = [
    boehmgc libatomic_ops pcre libevent
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv
  ];

  nativeBuildInputs = [ which makeWrapper ];

  buildInputs = libs ++ [ llvm ];

  libPath = stdenv.lib.makeLibraryPath libs;

  sourceRoot = "${name}";

  preBuild = ''
    patchShebangs bin/crystal
    patchShebangs ../${prebuiltName}/bin/crystal
    export PATH="$(pwd)/../${prebuiltName}/bin:$PATH"
  '';

  makeFlags = [ "CRYSTAL_CONFIG_VERSION=${version}"
                "FLAGS=--no-debug"
                "release=1"
                "all" "docs"
              ];

  installPhase = ''
    install -Dm755 .build/crystal $out/bin/crystal
    wrapProgram $out/bin/crystal \
        --suffix PATH : ${clang}/bin \
        --suffix CRYSTAL_PATH : lib:$out/lib/crystal \
        --suffix LIBRARY_PATH : $libPath
    install -dm755 $out/lib/crystal
    cp -r src/* $out/lib/crystal/

    install -dm755 $out/share/doc/crystal/api
    cp -r docs/* $out/share/doc/crystal/api/
    cp -r samples $out/share/doc/crystal/

    install -Dm644 etc/completion.bash $out/share/bash-completion/completions/crystal
    install -Dm644 etc/completion.zsh $out/share/zsh/site-functions/_crystal

    install -Dm644 man/crystal.1 $out/share/man/man1/crystal.1

    install -Dm644 LICENSE $out/share/licenses/crystal/LICENSE
  '';

  dontStrip = true;

  enableParallelBuilding = false;

  meta = {
    description = "A compiled language with Ruby like syntax and type inference";
    homepage = https://crystal-lang.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ manveru david50407 ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
