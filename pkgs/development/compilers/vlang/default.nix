{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx }:

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

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "local=1"
    "VC=${vc}"
    # vlang seems to want to write to $HOME/.vmodules , so lets give
    # it a writable HOME
    "HOME=$TMPDIR"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib,share}
    cp -r examples $out/share
    cp -r {cmd,vlib,thirdparty} $out/lib
    mv v $out/lib
    ln -s $out/lib/v $out/bin/v
    wrapProgram $out/bin/v --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
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
