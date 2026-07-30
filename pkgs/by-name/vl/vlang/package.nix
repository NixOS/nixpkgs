{
  lib,
  stdenv,
  fetchFromGitHub,
  glfw,
  freetype,
  openssl,
  makeWrapper,
  pkg-config,
  sqlite,
  upx,
  boehmgc,
  libxdmcp,
  libxau,
  libx11,
  xorgproto,
  binaryen,
}:

let
  version = "0.5.2";
  ptraceSubstitution = ''
    #include <sys/types.h>
    #include <sys/ptrace.h>
  '';
  # vc is the V compiler's source translated to C (needed for bootstrap).
  # So we fix its rev to correspond to the V version.
  vc = stdenv.mkDerivation {
    pname = "v.c";
    version = "0.5.2";
    src = fetchFromGitHub {
      owner = "vlang";
      repo = "vc";
      rev = "7eb8c54a3843e5107d5af06d7a8c3e928f322475";
      hash = "sha256-Ca8RqMN2BwnwCfjvtGtFAl/qaoSLQTHGmhIk5FN3CO8=";
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
    rev = "ef2f1018c37c1db6e379331b3cd841331b6a6fd2";
    hash = "sha256-drhDQYm7yiL+EDyslkTb0MGA9NQRrDLVg3IElwXAIIY=";
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
    hash = "sha256-0PInqMmb4sNzJwVD9SMhTXzvxMdaC1uIJl7fpdXKESE=";
  };

  propagatedBuildInputs = [
    glfw
    freetype
    openssl
    sqlite
  ]
  ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    binaryen
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxau
    libxdmcp
    xorgproto
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
    cp v v.mod $out/lib
    ln -s $out/lib/v $out/bin/v
    wrapProgram $out/bin/v \
      --prefix PATH : ${
        lib.makeBinPath [
          stdenv.cc
          pkg-config
        ]
      } \
      --prefix PKG_CONFIG_PATH : ${lib.getDev sqlite}/lib/pkgconfig

    # gen_vc is a V-maintainer tool for pushing bootstrap C files to the vc
    # repo; it requires network/SSH access, so it cannot be built in the Nix
    # sandbox.
    rm $out/lib/cmd/tools/gen_vc.v

    mkdir -p $HOME/.vmodules;
    ln -sf ${markdown} $HOME/.vmodules/markdown
    $out/lib/v -v build-tools
    $out/lib/v -v $out/lib/cmd/tools/vdoc
    $out/lib/v -v $out/lib/cmd/tools/vast
    $out/lib/v -v $out/lib/cmd/tools/vvet
    $out/lib/v -v $out/lib/cmd/tools/vcreate

    runHook postInstall
  '';

  meta = {
    homepage = "https://vlang.io/";
    changelog = "https://github.com/vlang/v/releases/tag/${version}";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      delta231
    ];
    mainProgram = "v";
    platforms = lib.platforms.all;
  };
}
