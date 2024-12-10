{
  lib,
  stdenv,
  fetchFromGitHub,
  glfw,
  freetype,
  openssl,
  makeWrapper,
  upx,
  boehmgc,
  xorg,
  binaryen,
  darwin,
}:

let
  version = "0.4.8";
  ptraceSubstitution = ''
    #include <sys/types.h>
    #include <sys/ptrace.h>
  '';
  # vc is the V compiler's source translated to C (needed for boostrap).
  # So we fix its rev to correspond to the V version.
  vc = stdenv.mkDerivation {
    pname = "v.c";
    version = "0.4.8";
    src = fetchFromGitHub {
      owner = "vlang";
      repo = "vc";
      rev = "54beb1f416b404a06b894e6883a0e2368d80bc3e";
      hash = "sha256-hofganRnWPRCjjsItwF2BKam4dCqzMCrjgWSjZLSrlo=";
    };

    # patch the ptrace reference for darwin
    installPhase =
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        substituteInPlace v.c \
          --replace "#include <sys/ptrace.h>" "${ptraceSubstitution}"
      ''
      + ''
        mkdir -p $out
        cp v.c $out/
      '';
  };
  # Required for vdoc.
  markdown = fetchFromGitHub {
    owner = "vlang";
    repo = "markdown";
    rev = "0c280130cb7ec410b7d21810d1247956c15b72fc";
    hash = "sha256-Fmhkrg9DBiWxInostNp+WfA3V5GgEIs5+KIYrqZosqY=";
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
    hash = "sha256-V4f14TcuKW8unzlo6i/tE6MzSb3HAll478OU2LxiTPQ=";
  };

  propagatedBuildInputs = [
    glfw
    freetype
    openssl
  ] ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs =
    [
      binaryen
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Cocoa
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
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
    $out/lib/v -v $out/lib/cmd/tools/vcreate

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://vlang.io/";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [
      Madouura
      delta231
    ];
    mainProgram = "v";
    platforms = platforms.all;
  };
}
