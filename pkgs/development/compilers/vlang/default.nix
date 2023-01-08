{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, boehmgc
, upx
, xorg
, libGL
, freetype
, openssl
}:

let
  targetSystem = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";
  staticBoehmgc = boehmgc.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags ++ [ "--enable-static" ];
  });
in
stdenv.mkDerivation rec {
  buildWithUpx = false; # Enable "-compress" flag.
  buildWithX11 = false; # Enable X11 support.
  buildWithWeb = false; # Enable web support.

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

  buildInputs = [ staticBoehmgc ];

  propagatedBuildInputs = [
  ] ++ lib.optional buildWithUpx [
    upx
  ] ++ lib.optional buildWithX11 [
    xorg.libX11.dev
    xorg.libXi.dev
    xorg.libXcursor.dev
    libGL.dev
    freetype
  ] ++ lib.optional buildWithWeb [
    openssl
  ];

  makeFlags = [
    "local=1"
    "VC=${vc}"
  ];

  preBuild = ''
    export HOME=$(mktemp -d)

    # We need to set the target system, because the auto-detection doesn't work that great.
    export VFLAGS="-os ${targetSystem} -showcc -skip-unused"

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
    # We need to patch the shebangs to point to our v
    sed -i "1s|.*|#!$out/bin/v -raw-vsh-tmp-prefix tmp|" $out/lib/cmd/tools/git_pre_commit_hook.vsh
    sed -i "1s|.*|#!$out/bin/v -raw-vsh-tmp-prefix tmp|" $out/lib/vlib/v/tests/script_with_no_extension
  '';

  meta = with lib; {
    homepage = "https://vlang.io/";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
    mainProgram = "v";
    platforms = platforms.unix;
  };
}
