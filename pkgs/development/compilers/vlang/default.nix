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

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "sha256-fHn1z2q3LmSycCOa1ii4DoHvbEW4uJt3Psq3/VuZNVQ=";
  };

  propagatedBuildInputs = [ glfw freetype openssl ]
    ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [ makeWrapper ];

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
