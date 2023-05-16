{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx, pkgsStatic, xorg, binaryen }:

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

  makeFlags = [
    "local=1"
  ];

  env.VC = vc;
  env.VFLAGS = if stdenv.isDarwin then
    # on darwin we need to add a manual link to libgc since it doesn't have a libgc.a
    "-cg -cc ${pkgsStatic.clang}/bin/clang -no-retry-compilation -ldflags -L${pkgsStatic.boehmgc}/lib -ldflags -lgc -ldflags -L${binaryen}/lib"
  else
    # libX11.dev and xorg.xorgproto are needed because of
    # builder error: Header file <X11/Xlib.h>, needed for module `clipboard.x11` was not found. Please install a package with the X11 development headers, for example: `apt-get install libx11-dev`.
    # libXau, libxcb, libXdmcp need to be static if you use static gcc otherwise
    # /nix/store/xnk2z26fqy86xahiz3q797dzqx96sidk-glibc-2.37-8/lib/libc.so.6: undefined reference to `_rtld_glob al_ro@GLIBC_PRIVATE'
    "-cc ${pkgsStatic.gcc}/bin/gcc -no-retry-compilation -cflags -I${xorg.libX11.dev}/include -cflags -I${xorg.xorgproto}/include -ldflags -L${binaryen}/lib -ldflags -L${pkgsStatic.xorg.libX11}/lib -ldflags -L${pkgsStatic.xorg.libxcb}/lib -ldflags -lxcb -ldflags -L${pkgsStatic.xorg.libXau}/lib -ldflags -lXau -ldflags -L${pkgsStatic.xorg.libXdmcp}/lib -ldflags -lXdmcp";

  preBuild = ''
    export HOME=$(mktemp -d)
    mkdir -p ./thirdparty/tcc/lib
    # this step is not needed it's just to silence a warning
    # we don't use tcc at all since it fails on a missing libatomic
    ln -s ${pkgsStatic.tinycc}/bin/tcc ./thirdparty/tcc/tcc.exe
    cp -r ${pkgsStatic.boehmgc}/lib/* ./thirdparty/tcc/lib
  '' + lib.optionalString stdenv.isDarwin ''
    # this file isn't used by clang, but it's just to silence a warning
    # the compiler complains on an empty file, so this makes it "close" to real
    substituteInPlace vlib/builtin/builtin_d_gcboehm.c.v \
        --replace "libgc.a" "libgc.la"
  '';

  # vcreate_test.v requires git, so we must remove it when building the tools.
  # vtest.v fails on Darwin, so let's just disable it for now.
  preInstall = ''
    mv cmd/tools/vcreate/vcreate_test.v $HOME/vcreate_test.v
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

  meta = with lib; {
    homepage = "https://vlang.io/";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
    mainProgram = "v";
    platforms = platforms.all;
  };
}
