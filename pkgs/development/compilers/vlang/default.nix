{ stdenv, fetchFromGitHub, glfw, freetype, curl }:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = "${version}";
    sha256 = "08zgwy9ac3wa5ixy8rdw6izpn1n1c3ydb9rl8z8graw0bgv719ma";
  };

  # V compiler source translated to C for bootstrap.
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "${version}";
    sha256 = "0k6c7v3r3cirypsqbaq10qlgg41v19rsnc1ygam4il2p8rsmfwz3";
  };

  enableParallelBuilding = true;
  buildInputs = [ glfw freetype curl ];

  buildPhase = ''
    runHook preBuild
    cc -std=gnu11 -w -o v $vc/v.c -lm
    ./v -prod -o v compiler
    # -fPIC -pie required for examples/hot_code_reloading
    make CFLAGS+="-fPIC -pie" thirdparty
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/vlang,share/vlang}
    cp -r examples $out/share/vlang
    cp -r {vlib,thirdparty} $out/lib/vlang
    cp v $out/lib/vlang
    ln -s $out/lib/vlang/v $out/bin/v
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://vlang.io/";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
