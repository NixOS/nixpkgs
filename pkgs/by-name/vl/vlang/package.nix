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
}:

let
  version = "0.4.11";
  ptraceSubstitution = ''
    #include <sys/types.h>
    #include <sys/ptrace.h>
  '';
  # vc is the V compiler's source translated to C (needed for bootstrap).
  # So we fix its rev to correspond to the V version.
  vc = stdenv.mkDerivation {
    pname = "v.c";
    version = "0.4.11";
    src = fetchFromGitHub {
      owner = "vlang";
      repo = "vc";
      rev = "a17f1105aa18b604ed8dac8fa5ca9424362c6e15";
      hash = "sha256-DAsVr1wtRfGbKO74Vfq7ejci+zQabSWeir8njbHYV3o=";
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
    hash = "sha256-K5B/fjdCYLE14LPg3ccS+sGC8CS7jZiuuxYkHvljGFA=";
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
      delta231
    ];
    mainProgram = "v";
    platforms = platforms.all;
  };
}
