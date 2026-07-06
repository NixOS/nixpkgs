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
  libxdmcp,
  libxau,
  libx11,
  xorgproto,
  binaryen,
}:

let
  version = "0.5";
  ptraceSubstitution = ''
    #include <sys/types.h>
    #include <sys/ptrace.h>
  '';
  # vc is the V compiler's source translated to C (needed for bootstrap).
  # So we fix its rev to correspond to the V version.
  vc = stdenv.mkDerivation {
    pname = "v.c";
    version = "0.5";
    src = fetchFromGitHub {
      owner = "vlang";
      repo = "vc";
      rev = "294bff4ef87427743d0b35c0f7eb1b34a6dd061b";
      hash = "sha256-NZR9Sxa9+iI0hGjB7Hwxl24K0Ra6ZJiUTk9yHp1J7kw=";
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
    rev = "5a1c9d82669e765493abe19488eaef0252c97dac";
    hash = "sha256-d/HGVYbbMv7cmF3I4LzD6N0gXSd8CJlPp0la3nPe1dw=";
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
    hash = "sha256-iS9tXeEsEjxEpgJNjz/08MQfZkSfFZWHy0CMurITr+E=";
  };

  propagatedBuildInputs = [
    glfw
    freetype
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [ makeWrapper ];

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
    cp v $out/lib
    ln -s $out/lib/v $out/bin/v
    wrapProgram $out/bin/v --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}

    # gen_vc is a V-maintainer tool for pushing bootstrap C files to the vc
    # repo; it requires network/SSH access and a v.mod root that doesn't exist
    # in the installed layout, so it cannot be built in the Nix sandbox.
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
