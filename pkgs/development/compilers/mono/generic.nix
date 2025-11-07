{
  lib,
  stdenv,
  bison,
  pkg-config,
  glib,
  gettext,
  perl,
  libgdiplus,
  libX11,
  ncurses,
  zlib,
  bash,
  cacert,
  python3,
  version,
  src,
  autoconf,
  libtool,
  automake,
  cmake,
  which,
  gnumake42,
  enableParallelBuilding ? true,
  extraPatches ? [ ],
  env ? { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mono";
  inherit version src env;

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
    gettext
  ];
  buildInputs = [
    glib
    gettext
    libgdiplus
    libX11
    ncurses
    zlib
    bash
  ];

  configureFlags = [
    "--x-includes=${libX11.dev}/include"
    "--x-libraries=${libX11.out}/lib"
    "--with-libgdiplus=${libgdiplus}/lib/libgdiplus.so"
  ];

  configurePhase = ''
    patchShebangs autogen.sh mcs/build/start-compiler-server.sh
    ./autogen.sh --prefix $out $configureFlags
  '';

  # We want pkg-config to take priority over the dlls in the Mono framework and the GAC
  # because we control pkg-config
  patches = [ ./pkgconfig-before-gac.patch ] ++ extraPatches;

  # Patch all the necessary scripts
  preBuild = ''
    makeFlagsArray=(INSTALL=`type -tp install`)
    substituteInPlace mcs/class/corlib/System/Environment.cs --replace-fail /usr/share "$out/share"
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
  postInstall = ''
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
    # Per nixpkgs#151720 the build failures for aarch64-darwin are fixed since 6.12.0.129.
    # Cross build is broken due to attempt to execute cert-sync built for the host.
    broken =
      (
        stdenv.hostPlatform.isDarwin
        && stdenv.hostPlatform.isAarch64
        && lib.versionOlder finalAttrs.version "6.12.0.129"
      )
      || !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
    homepage =
      if lib.versionOlder finalAttrs.version "6.14.0" then
        "https://mono-project.com/"
      else
        "https://gitlab.winehq.org/mono/mono";
    description = "Cross platform, open source .NET development framework";
    platforms = with platforms; darwin ++ linux;
    knownVulnerabilities = lib.optionals (lib.versionOlder finalAttrs.version "6.14.0") [
      ''
        mono was archived upstream, see https://www.mono-project.com/
        While WineHQ has taken over development, consider using 6.14.0 or newer.
      ''
    ];
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
    mainProgram = "mono";
  };
})
