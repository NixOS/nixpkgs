{ stdenv, fetchurl, boehmgc, libatomic_ops, pcre, libevent, libiconv, llvm, makeWrapper }:

stdenv.mkDerivation rec {
  name = "crystal-${version}";
  version = "0.24.2";

  src = fetchurl {
    url = "https://github.com/crystal-lang/crystal/archive/${version}.tar.gz";
    sha256 = "1l7nrrfgz1yxxjphypwzlxj6dbari20p71zb4l0gix09lmas8l6y";
  };

  prebuiltName = "crystal-0.24.2-1";
  prebuiltSrc = let arch = {
    "x86_64-linux" = "linux-x86_64";
    "i686-linux" = "linux-i686";
    "x86_64-darwin" = "darwin-x86_64";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");
  in fetchurl {
    url = "https://github.com/crystal-lang/crystal/releases/download/0.24.2/${prebuiltName}-${arch}.tar.gz";
    sha256 = {
      "x86_64-linux" = "1xf6riwd5k5f95988m1hsppsfii5v96svgmy12ncy7mgmm7k4dh3";
      "i686-linux" = "0ar05kj89pm3zxfnxwhf0mz9vrd9q5p47y4969sh0r6knccri0kp";
      "x86_64-darwin" = "1vz8bi5rfgggiic4ayxbcf6pfmdjvqcg4lsivnk2fyshr1m8l0h5";
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

  nativeBuildInputs = [ makeWrapper ];

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

  enableParallelBuilding = true;

  meta = {
    description = "A compiled language with Ruby like syntax and type inference";
    homepage = https://crystal-lang.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ sifmelcara david50407 ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
