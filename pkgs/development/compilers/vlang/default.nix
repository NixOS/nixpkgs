{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx }:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "weekly.2022.19";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "1bl91j3ip3i84jq3wg03sflllxv38sv4dc072r302rl2g9f4dbg6";
  };

  # Required for bootstrap.
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "a298ad7069f6333ef8ab59a616654fc74e04c847";
    sha256 = "168cgq6451hcgsxzyd8vq11g01642bs5kkwxqh6rz3rnc86ajic0";
  };

  # Required for vdoc.
  markdown = fetchFromGitHub {
    owner = "vlang";
    repo = "markdown";
    rev = "bbbd324a361e404ce0682fc00666df3a7877b398";
    sha256 = "0cawzizr3rjz81blpvxvxrcvcdai1adj66885ss390444qq1fnv7";
  };

  # vcreate_test.v requires git, so we must disable it.
  patches = [
    ./disable_vcreate_test.patch
  ];

  propagatedBuildInputs = [ glfw freetype openssl ]
    ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "local=1"
    "VC=${vc}"
  ];

  prePatch = ''
    export HOME=$(mktemp -d)
    cp cmd/tools/vcreate_test.v $HOME/vcreate_test.v
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

    # Return the pre-patch vcreate_test.v now that we no longer need the alteration.
    cp $HOME/vcreate_test.v $out/lib/cmd/tools/vcreate_test.v

    runHook postInstall
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
