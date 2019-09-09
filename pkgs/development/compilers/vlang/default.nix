{ stdenv, fetchFromGitHub, glfw, freetype, openssl }:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "0js92v2r1h4vaaha3z1spgi7qynlmr9vls41gxp284w4yhnjzv15";
  };

  # V compiler source translated to C for bootstrap.
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = version;
    sha256 = "0qx1drs1hr94w7vaaq5w8mkq7j1d3biffnmxkyz63yv8573k03bj";
  };

  enableParallelBuilding = true;
  buildInputs = [ glfw freetype openssl ];

  buildPhase = ''
    runHook preBuild
    cc -std=gnu11 $CFLAGS -w -o v $vc/v.c -lm $LDFLAGS
    ./v -prod -o v compiler
    make thirdparty
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
