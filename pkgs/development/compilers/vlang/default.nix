<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx, boehmgc, xorg, binaryen, darwin }:

let
  version = "weekly.2023.19";
  ptraceSubstitution = ''
    #include <sys/types.h>
    #include <sys/ptrace.h>
  '';
  # Required for bootstrap.
  vc = stdenv.mkDerivation {
    pname = "v.c";
    version = "unstable-2023-05-14";
    src = fetchFromGitHub {
      owner = "vlang";
      repo = "vc";
      rev = "f7c2b5f2a0738d0d236161c9de9f31dd0280ac86";
      sha256 = "sha256-xU3TvyNgc0o4RCsHtoC6cZTNaue2yuAiolEOvP37TKA=";
    };

    # patch the ptrace reference for darwin
    installPhase = lib.optionalString stdenv.isDarwin ''
      substituteInPlace v.c \
        --replace "#include <sys/ptrace.h>" "${ptraceSubstitution}"
    '' + ''
      mkdir -p $out
      cp v.c $out/
    '';
  };
  # Required for vdoc.
  markdown = fetchFromGitHub {
    owner = "vlang";
    repo = "markdown";
    rev = "6e970bd0a7459ad7798588f1ace4aa46c5e789a2";
    hash = "sha256-hFf7c8ZNMU1j7fgmDakuO7tBVr12Wq0dgQddJnkMajE=";
  };
  boehmgcStatic = boehmgc.override {
    enableStatic = true;
  };
in
stdenv.mkDerivation {
  pname = "vlang";
  inherit version;
=======
{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx }:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "weekly.2022.20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-fHn1z2q3LmSycCOa1ii4DoHvbEW4uJt3Psq3/VuZNVQ=";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ glfw freetype openssl ]
    ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [ makeWrapper ];

<<<<<<< HEAD
  buildInputs = [
    binaryen
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
  ] ++ lib.optionals stdenv.isLinux [
    xorg.libX11
    xorg.libXau
    xorg.libXdmcp
    xorg.xorgproto
  ];

  makeFlags = [
    "local=1"
  ];

  env.VC = vc;

  preBuild = ''
    export HOME=$(mktemp -d)
    mkdir -p ./thirdparty/tcc/lib
    cp -r ${boehmgcStatic}/lib/* ./thirdparty/tcc/lib
  '';

  # vcreate_test.v requires git, so we must remove it when building the tools.
  preInstall = ''
    mv cmd/tools/vcreate/vcreate_test.v $HOME/vcreate_test.v
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
  '' + lib.optionalString stdenv.isDarwin ''
    cp $HOME/vtest.v $out/lib/cmd/tools/vtest.v
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
