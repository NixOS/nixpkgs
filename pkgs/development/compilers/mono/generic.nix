{
  lib,
  stdenv,
  fetchurl,
  bison,
  pkg-config,
  glib,
  gettext,
  perl,
  libgdiplus,
  libX11,
  callPackage,
  ncurses,
  zlib,
  bash,
  withLLVM ? false,
  cacert,
  Foundation,
  libobjc,
  python3,
  version,
  sha256,
  autoconf,
  libtool,
  automake,
  cmake,
  which,
  gnumake42,
  enableParallelBuilding ? true,
  srcArchiveSuffix ? "tar.bz2",
  extraPatches ? [ ],
}:

let
  llvm = callPackage ./llvm.nix { };
in
stdenv.mkDerivation rec {
  pname = "mono";
  inherit version;

  src = fetchurl {
    inherit sha256;
    url = "https://download.mono-project.com/sources/mono/${pname}-${version}.${srcArchiveSuffix}";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoconf
    automake
    bison
    cmake
    libtool
    perl
    pkg-config
    python3
    which
    gnumake42
  ];
  buildInputs =
    [
      glib
      gettext
      libgdiplus
      libX11
      ncurses
      zlib
      bash
    ]
    ++ lib.optionals stdenv.isDarwin [
      Foundation
      libobjc
    ];

  configureFlags =
    [
      "--x-includes=${libX11.dev}/include"
      "--x-libraries=${libX11.out}/lib"
      "--with-libgdiplus=${libgdiplus}/lib/libgdiplus.so"
    ]
    ++ lib.optionals withLLVM [
      "--enable-llvm"
      "--with-llvm=${llvm}"
    ];

  configurePhase = ''
    patchShebangs autogen.sh mcs/build/start-compiler-server.sh
    ./autogen.sh --prefix $out $configureFlags
  '';

  # We want pkg-config to take priority over the dlls in the Mono framework and the GAC
  # because we control pkg-config
  patches = [ ./pkgconfig-before-gac.patch ] ++ extraPatches;

  # Patch all the necessary scripts. Also, if we're using LLVM, we fix the default
  # LLVM path to point into the Mono LLVM build, since it's private anyway.
  preBuild =
    ''
      makeFlagsArray=(INSTALL=`type -tp install`)
      substituteInPlace mcs/class/corlib/System/Environment.cs --replace /usr/share "$out/share"
    ''
    + lib.optionalString withLLVM ''
      substituteInPlace mono/mini/aot-compiler.c --replace "llvm_path = g_strdup (\"\")" "llvm_path = g_strdup (\"${llvm}/bin/\")"
    '';

  # Fix mono DLLMap so it can find libX11 to run winforms apps
  # libgdiplus is correctly handled by the --with-libgdiplus configure flag
  # Other items in the DLLMap may need to be pointed to their store locations, I don't think this is exhaustive
  # https://www.mono-project.com/Config_DllMap
  postBuild = ''
    find . -name 'config' -type f | xargs \
    sed -i -e "s@libX11.so.6@${libX11.out}/lib/libX11.so.6@g"
  '';

  # Without this, any Mono application attempting to open an SSL connection will throw with
  # The authentication or decryption has failed.
  # ---> Mono.Security.Protocol.Tls.TlsException: Invalid certificate received from server.
  postInstall =
    ''
      echo "Updating Mono key store"
      $out/bin/cert-sync ${cacert}/etc/ssl/certs/ca-bundle.crt
    ''
    # According to [1], gmcs is just mcs
    # [1] https://github.com/mono/mono/blob/master/scripts/gmcs.in
    + ''
      ln -s $out/bin/mcs $out/bin/gmcs
    '';

  inherit enableParallelBuilding;

  meta = with lib; {
    # Per nixpkgs#151720 the build failures for aarch64-darwin are fixed since 6.12.0.129
    broken = stdenv.isDarwin && stdenv.isAarch64 && lib.versionOlder version "6.12.0.129";
    homepage = "https://mono-project.com/";
    description = "Cross platform, open source .NET development framework";
    platforms = with platforms; darwin ++ linux;
    maintainers = with maintainers; [
      thoughtpolice
      obadz
    ];
    license = with licenses; [
      # runtime, compilers, tools and most class libraries licensed
      mit
      # runtime includes some code licensed
      bsd3
      # mcs/class/I18N/mklist.sh marked GPLv2 and others just GPL
      gpl2Only
      # RabbitMQ.Client class libraries dual licensed
      mpl20
      asl20
      # mcs/class/System.Core/System/TimeZoneInfo.Android.cs
      asl20
      # some documentation
      mspl
      # https://www.mono-project.com/docs/faq/licensing/
      # https://github.com/mono/mono/blob/main/LICENSE
    ];
  };
}
