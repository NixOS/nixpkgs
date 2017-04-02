{ stdenv, fetchurl, boehmgc, libatomic_ops, pcre, libevent, libiconv, llvm_39, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.21.0";
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
        "x86_64-linux" = "0a44539df3813baea4381c314ad5f782b13cf1596e478851c52cd84193cc7a1f";
        "i686-linux" = "9a45287f94d329f5ebe77f5a0d71cd0e09c3db79b0b56f6fe4a5166beed707ef";
        "x86_64-darwin" = "e92abb33a9a592febb4e629ad68375b2577acd791a71220b8dc407904be469ee";
      }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");
  };

  src = fetchurl {
    url = "https://github.com/crystal-lang/crystal/archive/${version}.tar.gz";
    sha256 = "4dd01703f5304a0eda7f02fc362fba27ba069666097c0f921f8a3ee58808779c";
  };

  # crystal on Darwin needs libiconv to build
  buildInputs = [
    boehmgc libatomic_ops pcre libevent llvm_39 makeWrapper
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

