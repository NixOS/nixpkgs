{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx, boehmgc, xorg, binaryen, darwin }:

let
  version = "weekly.2023.42";
  ptraceSubstitution = ''
    #include <sys/types.h>
    #include <sys/ptrace.h>
  '';
  # Required for bootstrap.
  vc = stdenv.mkDerivation {
    pname = "v.c";
    version = "unstable-2023-10-17";
    src = fetchFromGitHub {
      owner = "vlang";
      repo = "vc";
      rev = "bbfdece2ef5cab8a52b03c4df1ca0f803639069b";
      hash = "sha256-UdifiUDTivqJ94NJB25mF/xXeiEAE55QaIUwWwdAllQ=";
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
    rev = "3a173bee57a48dcfc1c0177555e45116befac48e";
    hash = "sha256-TWiCUMzAzHidtzXEYtUQ7uuksW+EIjE/fZ+s2Mr+uWI=";
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
    hash = "sha256-sQ3M6tMufL560lvtWoa5f5MpOT4D8K5uq4kDPHNmUog=";
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
    $out/lib/v -v $out/lib/cmd/tools/vcreate

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
