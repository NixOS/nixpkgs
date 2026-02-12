{
  lib,
  fetchFromGitHub,
  pkg-config,
  runCommand,
  writeText,
  wrapGAppsHook3,
  withNvenc ? false,
  atk,
  cairo,
  cudatoolkit,
  cudaPackages,
  ffmpeg,
  gdk-pixbuf,
  getopt,
  glib,
  gobject-introspection,
  gst_all_1,
  gtk3,
  libappindicator,
  libfakexinerama,
  librsvg,
  libvpx,
  libwebp,
  systemd,
  lz4,
  nv-codec-headers-10,
  nvidia_x11 ? null,
  pam,
  pandoc,
  pango,
  pulseaudioFull,
  python3,
  stdenv,
  util-linux,
  which,
  x264,
  x265,
  libavif,
  openh264,
  libyuv,
  xauth,
  xdg-utils,
  xkeyboard-config,
  xf86-video-dummy,
  libxtst,
  libxres,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxdamage,
  libxcomposite,
  libx11,
  xorgproto,
  libxkbfile,
  xorg-server,
  xxHash,
  clang,
  withHtml ? true,
  xpra-html5,
  udevCheckHook,
}:

let
  inherit (python3.pkgs) cython buildPythonApplication;

  xf86videodummy = xf86-video-dummy.overrideDerivation (p: {
    patches = [
      # patch provided by Xpra upstream
      ./0002-Constant-DPI.patch
      # https://github.com/Xpra-org/xpra/issues/349
      ./0003-fix-pointer-limits.patch
    ];
  });

  xorgModulePaths = writeText "module-paths" ''
    Section "Files"
      ModulePath "${xorg-server}/lib/xorg/modules"
      ModulePath "${xorg-server}/lib/xorg/modules/extensions"
      ModulePath "${xorg-server}/lib/xorg/modules/drivers"
      ModulePath "${xf86videodummy}/lib/xorg/modules/drivers"
    EndSection
  '';

  nvencHeaders =
    runCommand "nvenc-headers"
      {
        inherit nvidia_x11;
      }
      ''
        mkdir -p $out/include $out/lib/pkgconfig
        cp ${nv-codec-headers-10}/include/ffnvcodec/nvEncodeAPI.h $out/include
        substituteAll ${./nvenc.pc} $out/lib/pkgconfig/nvenc.pc
      '';

  nvjpegHeaders = runCommand "nvjpeg-headers" { } ''
    mkdir -p $out/include $out/lib/pkgconfig
    substituteAll ${cudaPackages.libnvjpeg.dev}/share/pkgconfig/nvjpeg.pc $out/lib/pkgconfig/nvjpeg.pc
  '';
  effectiveBuildPythonApplication = buildPythonApplication.override {
    stdenv = if withNvenc then cudaPackages.backendStdenv else stdenv;
  };
in
effectiveBuildPythonApplication rec {
  pname = "xpra";
  version = "6.3.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Xpra-org";
    repo = "xpra";
    tag = "v${version}";
    hash = "sha256-kXe/Pyjzf6CxYtsYP15hgYnj+qricrlXGqi/G3uQMFM=";
  };

  patches = [
    ./fix-41106.patch # https://github.com/NixOS/nixpkgs/issues/41106
    ./fix-122159.patch # https://github.com/NixOS/nixpkgs/issues/122159
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace xpra/platform/posix/features.py \
      --replace-fail "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open"

    patchShebangs --build fs/bin/build_cuda_kernels.py
  '';

  INCLUDE_DIRS = "${pam}/include";

  nativeBuildInputs = [
    clang
    gobject-introspection
    pkg-config
    wrapGAppsHook3
    pandoc
    udevCheckHook
  ]
  ++ lib.optional withNvenc cudatoolkit;

  buildInputs = [
    libx11
    libxcomposite
    libxdamage
    libxfixes
    libxi
    libxkbfile
    libxrandr
    libxrender
    libxres
    libxtst
    xorgproto
  ]
  ++ (with gst_all_1; [
    gst-libav
    gst-vaapi
    gst-plugins-ugly
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ])
  ++ [
    atk.out
    cairo
    cython
    ffmpeg
    gdk-pixbuf
    glib
    gtk3
    libappindicator
    librsvg
    libvpx
    libwebp
    lz4
    pam
    pango
    x264
    x265
    libavif
    openh264
    libyuv
    xxHash
    systemd
  ]
  ++ lib.optional withNvenc [
    nvencHeaders
    nvjpegHeaders
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    (
      [
        cryptography
        dbus-python
        gst-python
        idna
        lz4
        netifaces
        numpy
        opencv4
        pam
        paramiko
        pillow
        pycairo
        pycrypto
        pycups
        pygobject3
        pyinotify
        pyopengl
        pyopengl-accelerate
        python-uinput
        pyxdg
        rencode
        invoke
        aioquic
        uvloop
        pyopenssl
      ]
      ++ lib.optionals withNvenc [
        pycuda
        pynvml
      ]
    );

  # error: 'import_cairo' defined but not used
  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

  setupPyBuildFlags = [
    "--with-Xdummy"
    "--without-Xdummy_wrapper"
    "--without-strict"
    "--with-gtk3"
    # Override these, setup.py checks for headers in /usr/* paths
    "--with-pam"
    "--with-vsock"
  ]
  ++ lib.optional withNvenc [
    "--with-nvenc"
    "--with-nvjpeg_encoder"
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --set XPRA_INSTALL_PREFIX "$out"
      --set XPRA_COMMAND "$out/bin/xpra"
      --set XPRA_XKB_CONFIG_ROOT "${xkeyboard-config}/share/X11/xkb"
      --set XORG_CONFIG_PREFIX ""
      --prefix LD_LIBRARY_PATH : ${libfakexinerama}/lib
      --prefix PATH : ${
        lib.makeBinPath [
          getopt
          xorg-server
          xauth
          which
          util-linux
          pulseaudioFull
        ]
      }
  ''
  + lib.optionalString withNvenc ''
    --prefix LD_LIBRARY_PATH : ${nvidia_x11}/lib
  ''
  + ''
    )
  '';

  postInstall = ''
    # append module paths to xorg.conf
    cat ${xorgModulePaths} >> $out/etc/xpra/xorg.conf
    cat ${xorgModulePaths} >> $out/etc/xpra/xorg-uinput.conf

    # make application icon visible to desktop environemnts
    icon_dir="$out/share/icons/hicolor/64x64/apps"
    mkdir -p "$icon_dir"
    ln -sr "$out/share/icons/xpra.png" "$icon_dir"
  ''
  + lib.optionalString withHtml ''
    ln -s ${xpra-html5}/share/xpra/www $out/share/xpra/www;
  '';

  # doCheck = false;

  enableParallelBuilding = true;

  passthru = {
    inherit xf86videodummy;
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://xpra.org/";
    downloadPage = "https://xpra.org/src/";
    description = "Persistent remote applications for X";
    changelog = "https://github.com/Xpra-org/xpra/releases/tag/v${version}";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      numinit
      mvnetbiz
      lucasew
    ];
  };
}
