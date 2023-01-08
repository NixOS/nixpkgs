{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, boehmgc
}:

let
  targetSystem = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";
  staticBoehmgc = boehmgc.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags ++ [ "--enable-static" ];
  });
in
stdenv.mkDerivation rec {
  pname = "vlang";
  version = "weekly.2023.01";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "sha256-baHN9m2vrjPH0cIf7WoHcH5JH1HUFNpabQklY0jjKgQ=";
  };

  # Required for bootstrap.
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "086ca946e05f0ef6ad1c8bc1cb15d397db4ef2e7";
    sha256 = "TbivY4zoJKdMDSshvzi4yKhWrvlbUDq1FcKmNbCWZy4=";
  };

  # Required for vdoc.
  markdown = fetchFromGitHub {
    owner = "vlang";
    repo = "markdown";
    rev = "014724a2e35c0a7e46ea9cc91f5a303f2581b62c";
    sha256 = "jsL3m6hzNgQPKrQQhnb9mMELK1vYhvyS62sRBRwQ9CE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "local=1"
    "VC=${vc}"
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    # We need to set the target system, because the auto-detection doesn't work that great.
    export VFLAGS="-os ${targetSystem} -showcc -skip-unused"
    # We also need gc.h in the include path.
    export CFLAGS="-I${staticBoehmgc.dev}/include"
    export LDFLAGS="-L${staticBoehmgc}/lib"

    # patch the code to use our static compiled BoehmGC
    sed -i "s|@VEXEROOT/thirdparty/tcc/lib/libgc.a|${staticBoehmgc}/lib/libgc.a|" vlib/builtin/builtin_d_gcboehm.c.v
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

  preFixup = ''
    # We need to patch the shebang of file "lib/cmd/tools/git_pre_commit_hook.vsh"
    # and file "lib/vlib/v/tests/script_with_no_extension"
    # Going from "#!/usr/bin/env -S v -raw-vsh-tmp-prefix tmp"
    # To "#!$out/v -raw-vsh-tmp-prefix tmp"
    sed -i "1s|.*|#!$out/bin/v -raw-vsh-tmp-prefix tmp|" $out/lib/cmd/tools/git_pre_commit_hook.vsh
    sed -i "1s|.*|#!$out/bin/v -raw-vsh-tmp-prefix tmp|" $out/lib/vlib/v/tests/script_with_no_extension
  '';

  /* Details concerning features:
    If you want to use `-compress`, you need to add `upx` in your build inputs.
    If you want to build x11 apps (like examples/2048.v) you will need:
    - `xorg.libX11.dev`
    - `xorg.libXi.dev`
    - `xorg.libXcursor.dev`
    - `libGL.dev`
    - `freetype`
    If you want to build web apps (using `net.http` or `net.websocket`) you will need `openssl`.
  */
  meta = with lib; {
    homepage = "https://vlang.io/";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
    mainProgram = "v";
    platforms = platforms.unix;
  };
}
