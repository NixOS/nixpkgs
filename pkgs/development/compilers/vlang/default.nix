{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx }:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "weekly.2021.51";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "1jvq3fxckl2jidiigkvclacjxbg5k38268mck7bl1ky1yspgfrnq";
  };

  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "c8ed2cd82b247e94c33217dba35c420cfc02fef3";
    sha256 = "1acgx1qp480jmsv1xvqy1zf7iyy90mvg9x1m1b0zrwx09wz4y1cq";
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
