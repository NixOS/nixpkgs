{ stdenv, fetchurl, fetchFromGitHub, bison, pkgconfig
, glib, gettext, perl, libgdiplus, libX11, callPackage
, ncurses, zlib, autoconf, libtool, automake, which
, withLLVM ? false, fromGit ? false, cacert }:

let
  llvm     = callPackage ./llvm.nix { };
  llvmOpts = stdenv.lib.optionalString withLLVM "--enable-llvm --enable-llvmloaded --with-llvm=${llvm}";

  derivationAttrs = rec {
    name = "mono-${version}";
    version = "4.0.2.5";

    src = fetchurl {
      url = "http://download.mono-project.com/sources/mono/${name}.tar.bz2";
      sha256 = "0lfndz7l3j593wilyczb5w6kvrdbf2fsd1i46qlszfjvx975hx5h";
    };

    buildInputs = [bison pkgconfig glib gettext perl libgdiplus libX11 ncurses zlib];
    propagatedBuildInputs = [glib];

    NIX_LDFLAGS = "-lgcc_s" ;

    # To overcome the bug https://bugzilla.novell.com/show_bug.cgi?id=644723
    dontDisableStatic = true;

    # In fact I think this line does not help at all to what I
    # wanted to achieve: have mono to find libgdiplus automatically
    configureFlags = "--x-includes=${libX11}/include --x-libraries=${libX11}/lib --with-libgdiplus=${libgdiplus}/lib/libgdiplus.so ${llvmOpts}";

    # Attempt to fix this error when running "mcs --version":
    # The file /nix/store/xxx-mono-2.4.2.1/lib/mscorlib.dll is an invalid CIL image
    dontStrip = true;

    # Parallel building doesn't work, as shows http://hydra.nixos.org/build/2983601
    enableParallelBuilding = false;

    # We want pkg-config to take priority over the dlls in the Mono framework and the GAC
    # because we control pkg-config
    patches = [ ./pkgconfig-before-gac.patch ];

    preConfigure = ''
      patchShebangs ./
    '';

    # Patch all the necessary scripts. Also, if we're using LLVM, we fix the default
    # LLVM path to point into the Mono LLVM build, since it's private anyway.
    preBuild = ''
      makeFlagsArray=(INSTALL=`type -tp install`)
      substituteInPlace mcs/class/corlib/System/Environment.cs --replace /usr/share "$out/share"
    '' + stdenv.lib.optionalString withLLVM ''
      substituteInPlace mono/mini/aot-compiler.c --replace "llvm_path = g_strdup (\"\")" "llvm_path = g_strdup (\"${llvm}/bin/\")"
    '';

    # Fix mono DLLMap so it can find libX11 and gdiplus to run winforms apps
    # Other items in the DLLMap may need to be pointed to their store locations, I don't think this is exhaustive
    # http://www.mono-project.com/Config_DllMap
    postBuild = ''
      find . -name 'config' -type f | while read i; do
          sed -i "s@libX11.so.6@${libX11}/lib/libX11.so.6@g" $i
          sed -i "s@/.*libgdiplus.so@${libgdiplus}/lib/libgdiplus.so@g" $i
      done
    '';

    # Without this, any Mono application attempting to open an SSL connection will throw with
    # The authentication or decryption has failed.
    # ---> Mono.Security.Protocol.Tls.TlsException: Invalid certificate received from server.
    postInstall = ''
      echo "Updating Mono key store"
      $out/bin/cert-sync ${cacert}/etc/ssl/certs/ca-bundle.crt
    '';

    meta = {
      homepage = http://mono-project.com/;
      description = "Cross platform, open source .NET development framework";
      platforms = with stdenv.lib.platforms; linux;
      maintainers = with stdenv.lib.maintainers; [ viric thoughtpolice obadz ];
      license = stdenv.lib.licenses.free; # Combination of LGPL/X11/GPL ?
    };
  };

  monoStable = stdenv.mkDerivation derivationAttrs;

  monoGit = stdenv.mkDerivation (derivationAttrs // rec {
    name = "mono-${version}";
    version = "git-" + (builtins.substring 0 10 rev);
    rev = "ad600a087f534a16073e5294024b520168257eed";

    src = fetchFromGitHub {
      owner = "mono";
      repo = "mono";
      inherit rev;
      sha256 = "17fxyxygb59rvzrn4grkdl4cw5yc6da3b6azfbpwlk90vr8amdmr";
    };

    src_1 = fetchFromGitHub {
      owner = "mono";
      repo = "aspnetwebstack";
      rev = "e77b12e6cc5ed260a98447f609e887337e44e299";
      sha256 = "0rks344qr4fmp3fs1264d2qkmm348m8d1kjd7z4l94iiirwn1fq1";
    };

    src_2 = fetchFromGitHub {
      owner = "mono";
      repo = "Newtonsoft.Json";
      rev = "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4";
      sha256 = "0dgngd5hqk6yhlg40kabn6qdnknm32zcx9q6bm2w31csnsk5978s";
    };

    src_3 = fetchFromGitHub {
      owner = "mono";
      repo = "cecil";
      rev = "33d50b874fd527118bc361d83de3d494e8bb55e1";
      sha256 = "1p4hl1796ib26ykyf5snl6cj0lx0v7mjh0xqhjw6qdh753nsjyhb";
    };

    src_4 = fetchFromGitHub {
      owner = "directhex";
      repo = "mono-snapshot";
      rev = "9342f8f052f81deaba789f030db23a88b4369724";
      sha256 = "1ysaip5ba2yzrn0f4lqxais8ki7mq8h81n9rq3nxxvyfnznwbka1";
    };

    src_5 = fetchFromGitHub {
      owner = "mono";
      repo = "rx";
      rev = "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e";
      sha256 = "1n1jwhmsbkcv2d806immcpzkb72rz04xy98myw355a8w5ah25yiv";
    };

    src_6 = fetchFromGitHub {
      owner = "mono";
      repo = "ikvm-fork";
      rev = "dab43d5cf4bf3b8b9a5b5f8cb175dee38a5fe69f";
      sha256 = "05rjx783ihd3l2d6qxa8gzxwh7vfm8j6fbmay7pn9iqq97hcicmp";
    };

    src_7 = fetchFromGitHub {
      owner = "mono";
      repo = "ikdasm";
      rev = "3bf7a4b54385a2f3765a85c0bae23190169f5c0a";
      sha256 = "1rfddan5qah9ha2z6k4iym4b9x1aqa9i37c66vwg06nmz3ydm4gy";
    };

    src_8 = fetchFromGitHub {
      owner = "mono";
      repo = "referencesource";
      rev = "abe1cdfb1f941a03c477546534b33693a2ed1b40";
      sha256 = "11zwi87phrdhcx0w1kdb61mrdkxa6dnnmw2icwfyh14dlkvhn122";
    };

    src_9 = fetchFromGitHub {
      owner = "mono";
      repo = "reference-assemblies";
      rev = "7120b21603354fced392a43ab7c581d0114fecac";
      sha256 = "1ivfsm5ssfag5pbzr2qsgdxdcgs3q7qv76jfyflfgfk4j2laqczh";
    };

    src_10 = fetchFromGitHub {
      owner = "mono";
      repo = "Lucene.Net.Light";
      rev = "85978b7eb94738f516824341213d5e94060f5284";
      sha256 = "0d118i52m3a0vfjhfci81a2kc4qvnj23gs02hrvdrfpd1q92fyii";
    };

    prePatch = ''
      cp -rv ${src_1}/* ./external/aspnetwebstack
      cp -rv ${src_2}/* ./external/Newtonsoft.Json
      cp -rv ${src_3}/* ./external/cecil
      cp -rv ${src_4}/* ./external/debian-snapshot
      cp -rv ${src_5}/* ./external/rx
      cp -rv ${src_6}/* ./external/ikvm
      cp -rv ${src_7}/* ./external/ikdasm
      cp -rv ${src_8}/* ./external/referencesource
      cp -rv ${src_9}/* ./external/binary-reference-assemblies
      cp -rv ${src_10}/* ./external/Lucene.Net.Light
    '';

    preConfigure = derivationAttrs.preConfigure + ''
      ./autogen.sh
    '';

    # Need monoStable as an input to bootstrap
    buildInputs = derivationAttrs.buildInputs ++ [ autoconf libtool automake which monoStable ];
  });
in
  if fromGit then monoGit else monoStable
