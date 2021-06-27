{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, upx ? null }:

assert stdenv.hostPlatform.isUnix -> upx != null;

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "weekly.2021.25";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "0y4a5rmpcdqina32d6azbmsbi3zqqfl413sicg72x6a1pm2vg33j";
  };

  # V compiler source translated to C for bootstrap.
  # Use matching v.c release commit for now, 0.1.21 release is not available.
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "3201d2dd2faadfa370da0bad2a749a664ad5ade3";
    sha256 = "0xzkjdph5wfjr3qfkihgc27vsbbjh2l31rp8z2avq9hc531hwvrz";
  };

  propagatedBuildInputs = [ glfw freetype openssl ]
    ++ lib.optional stdenv.hostPlatform.isUnix upx;

  buildPhase = ''
    runHook preBuild
    cc -std=gnu11 $CFLAGS -w -o v $vc/v.c -lm $LDFLAGS
    # vlang seems to want to write to $HOME/.vmodules,
    # so lets give it a writable HOME
    HOME=$PWD ./v -prod self
    # Exclude thirdparty/vschannel as it is windows-specific.
    find thirdparty -path thirdparty/vschannel -prune -o -type f -name "*.c" -execdir cc -std=gnu11 $CFLAGS -w -c {} $LDFLAGS ';'
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib,share}
    cp -r examples $out/share
    cp -r {cmd,vlib,thirdparty} $out/lib
    mv v $out/lib
    ln -s $out/lib/v $out/bin/v
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://vlang.io/";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
