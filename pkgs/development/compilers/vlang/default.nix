{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx }:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "weekly.2022.20";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "1isbyfs98bdbm2qjf7q4bqbpsmdiqlavn3gznwr12bkvhnsf4j3x";
  };

  # Required for bootstrap.
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "167f262866090493650f58832d62d910999dd5a4";
    sha256 = "1xax8355qkrccjcmx24gcab88xnrqj15mhqy0bgp3v2rb1hw1n3a";
  };

  # Required for vdoc.
  markdown = fetchFromGitHub {
    owner = "vlang";
    repo = "markdown";
    rev = "bbbd324a361e404ce0682fc00666df3a7877b398";
    sha256 = "0cawzizr3rjz81blpvxvxrcvcdai1adj66885ss390444qq1fnv7";
  };

  propagatedBuildInputs = [ glfw freetype openssl ]
    ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "local=1"
    "VC=${vc}"
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # vcreate_test.v requires git, so we must remove it when building the tools.
  # vtest.v fails on Darwin, so let's just disable it for now.
  preInstall = ''
    mv cmd/tools/vcreate_test.v $HOME/vcreate_test.v
  '' + lib.optionalString stdenv.isDarwin ''
    mv cmd/tools/vtest.v $HOME/vtest.v
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,share}
    cp -r examples $out/share
    cp -r {cmd,vlib,thirdparty} $out/lib
    cp v $out/lib
    ln -s $out/lib/v $out/bin/v
    wrapProgram $out/bin/v --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}

    mkdir -p $HOME/.vmodules;
    ln -sf ${markdown} $HOME/.vmodules/markdown
    $out/lib/v -v build-tools
    $out/lib/v -v $out/lib/cmd/tools/vdoc
    $out/lib/v -v $out/lib/cmd/tools/vast
    $out/lib/v -v $out/lib/cmd/tools/vvet

    runHook postInstall
  '';

  # Return vcreate_test.v and vtest.v, so the user can use it.
  postInstall = ''
    cp $HOME/vcreate_test.v $out/lib/cmd/tools/vcreate_test.v
  '' + lib.optionalString stdenv.isDarwin ''
    cp $HOME/vtest.v $out/lib/cmd/tools/vtest.v
  '';

  meta = with lib; {
    homepage = "https://vlang.io/";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
    mainProgram = "v";
    platforms = platforms.all;
  };
}
