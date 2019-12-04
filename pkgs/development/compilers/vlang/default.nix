{ stdenv, fetchFromGitHub, glfw, freetype, openssl, upx ? null }:

assert stdenv.hostPlatform.isUnix -> upx != null;

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "0.1.23.1";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "0d3i6ay9ib9i5liybfl23hd6nl20wdkn5gspvwiyvajqygz2vffp";
  };

  # V compiler source translated to C for bootstrap.
  # Using matching v.c release commit
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "66368fffce007edc7f49fa8e51de5a07bac17773";
    sha256 = "02l7g81pp9k5jgbazpkdrqphy3pr075s0h8b3wfsyhrnjz13kdiq";
  };

  enableParallelBuilding = true;
  propagatedBuildInputs = [ glfw freetype openssl ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isUnix upx;

  patches = [
    ./compilation-fixes-after-a7054b6.patch
  ];

  buildPhase = ''
    runHook preBuild
    cc -std=gnu11 $CFLAGS -w -o v $vc/v.c -lm $LDFLAGS
    ./v -prod -cflags `$CFLAGS` -o v v.v
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
    maintainers = with maintainers; [ chiiruno filalex77 ];
    platforms = platforms.all;
  };
}
