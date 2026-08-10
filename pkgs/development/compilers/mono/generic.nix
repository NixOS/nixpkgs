{
  lib,
  stdenv,
  bison,
  pkg-config,
  glib,
  gettext,
  perl,
  libgdiplus,
  libx11,
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
  bootstrapMono ? null,
  enableParallelBuilding ? true,
  extraPatches ? [ ],
  env ? { },
}:

let
  useBootstrap = bootstrapMono != null;
in
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
  ]
  ++ lib.optional useBootstrap bootstrapMono;
  buildInputs = [
    glib
    gettext
    libgdiplus
    libx11
    ncurses
    zlib
    bash
  ];

  configureFlags = [
    "--x-includes=${libx11.dev}/include"
    "--x-libraries=${libx11.out}/lib"
    "--with-libgdiplus=${libgdiplus}/lib/libgdiplus.so"
  ]
  ++ lib.optional useBootstrap "--with-csc=mcs";

  postPatch = lib.optionalString useBootstrap ''
    find . -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete

    substituteInPlace mcs/class/aot-compiler/Makefile \
      --replace-fail "IMAGES = \$(mscorlib_aot_image) \$(mcs_aot_image) \$(CSC_IMAGES)" "IMAGES = \$(mscorlib_aot_image) \$(mcs_aot_image)"

    substituteInPlace mcs/Makefile \
      --replace-fail "net_4_x_SUBDIRS := build class ilasm tools tests errors docs mcs class/aot-compiler packages" \
                     "net_4_x_SUBDIRS := build class ilasm tools tests errors docs mcs class/aot-compiler"
  '';

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
  ''
  + lib.optionalString useBootstrap ''
    pushd external/binary-reference-assemblies
    for file in $(find . -name Makefile); do
      substituteInPlace "$file" \
        --replace-quiet "CSC_COMMON_ARGS := " "CSC_COMMON_ARGS := -delaysign+ "
      for reference in \
        "IBM.Data.DB2:System.Xml" "Mono.Data.Sqlite:System.Xml" \
        "System.Data.DataSetExtensions:System.Xml" "System.Data.OracleClient:System.Xml" \
        "System.IdentityModel:System.Configuration" "System.Design:Accessibility" \
        "System.Web.Extensions.Design:System.Windows.Forms System.Web" "System.ServiceModel.Routing:System.Xml" \
        "System.Web.Abstractions:System" "System.Reactive.Windows.Forms:System" \
        "System.Windows.Forms.DataVisualization:Accessibility" "Facades/System.ServiceModel.Primitives:System.Xml" \
        "Facades/System.Dynamic.Runtime:System" "Facades/System.Xml.XDocument:System.Xml" \
        "Facades/System.Runtime.Serialization.Xml:System.Xml" "Facades/System.Data.Common:System System.Xml"
      do
        assembly=''${reference%%:*}
        references=''${reference#*:}
        substituteInPlace "$file" \
          --replace-quiet "''${assembly}_REFS := " "''${assembly}_REFS := $references "
      done
    done
    if [ -f build/monodroid/Makefile ]; then
      substituteInPlace build/monodroid/Makefile \
        --replace-quiet "ECMA_KEY := ../../../../../mono/" "ECMA_KEY := ../../../../"
    fi
    make -j"$NIX_BUILD_CORES" V=1 SKIP_AOT=1 CSC=mcs
    popd
  ''
  + ''
    substituteInPlace mcs/class/corlib/System/Environment.cs --replace-fail /usr/share "$out/share"
  '';

  # Fix mono DLLMap so it can find libx11 to run winforms apps
  # libgdiplus is correctly handled by the --with-libgdiplus configure flag
  # Other items in the DLLMap may need to be pointed to their store locations, I don't think this is exhaustive
  # https://www.mono-project.com/Config_DllMap
  postBuild = ''
    find . -name 'config' -type f | xargs \
    sed -i -e "s@libX11.so.6@${libx11.out}/lib/libX11.so.6@g"
  '';

  # Without this, any Mono application attempting to open an SSL connection will throw with
  # The authentication or decryption has failed.
  # ---> Mono.Security.Protocol.Tls.TlsException: Invalid certificate received from server.
  postInstall = ''
    echo "Updating Mono key store"
    $out/bin/cert-sync ${cacert}/etc/ssl/certs/ca-bundle.crt
  ''
  + lib.optionalString useBootstrap ''
    [ -e "$out/lib/mono/4.5/csc.exe" ] || ln -sf mcs "$out/bin/csc"
    for tool in csi vbc; do
      [ -e "$out/lib/mono/4.5/$tool.exe" ] || rm -f "$out/bin/$tool"
    done
  ''
  # According to [1], gmcs is just mcs
  # [1] https://github.com/mono/mono/blob/master/scripts/gmcs.in
  + ''
    ln -s $out/bin/mcs $out/bin/gmcs
  '';

  inherit enableParallelBuilding;

  meta = {
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
    platforms = with lib.platforms; darwin ++ linux;
    knownVulnerabilities = lib.optionals (lib.versionOlder finalAttrs.version "6.14.0") [
      ''
        mono was archived upstream, see https://www.mono-project.com/
        While WineHQ has taken over development, consider using 6.14.0 or newer.
      ''
    ];
    maintainers = with lib.maintainers; [
      thoughtpolice
      obadz
    ];
    license = with lib.licenses; [
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
