{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx }:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "weekly.2022.07";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "sTnev6nxmaR8aSZJ9K70iZF84WkkoxOrbza9a+MTwxY=";
  };

  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "3155be181911eb94ada67fcfef0911df7017992c";
    sha256 = "SXf4F0c4aNSL+6Dze6W8cFSqJZr361gDNAjxPjduuHw=";
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
    description =
      "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
