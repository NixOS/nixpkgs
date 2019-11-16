{ stdenv, fetchFromGitHub, glfw, freetype, openssl, upx ? null }:

assert stdenv.hostPlatform.isUnix -> upx != null;

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "0npd7a7nhd6r9mr99naib9scqk30209hz18nxif27284ckjbl4fk";
  };

  # V compiler source translated to C for bootstrap.
  # Use matching v.c release commit for now, 0.1.21 release is not available.
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "950a90b6acaebad1c6ddec5486fc54307e38a9cd";
    sha256 = "1dh5l2m207rip1xj677hvbp067inw28n70ddz5wxzfpmaim63c0l";
  };

  enableParallelBuilding = true;
  propagatedBuildInputs = [ glfw freetype openssl ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isUnix upx;

  buildPhase = ''
    runHook preBuild
    cc -std=gnu11 $CFLAGS -w -o v $vc/v.c -lm $LDFLAGS
    ./v -prod -cflags `$CFLAGS` -o v compiler
    # Exclude thirdparty/vschannel as it is windows-specific.
    find thirdparty -path thirdparty/vschannel -prune -o -type f -name "*.c" -execdir cc -std=gnu11 $CFLAGS -w -c {} $LDFLAGS ';'
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib,share}
    cp -r examples $out/share
    cp -r {vlib,thirdparty} $out/lib
    cp v $out/lib
    ln -s $out/lib/v $out/bin/v
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
