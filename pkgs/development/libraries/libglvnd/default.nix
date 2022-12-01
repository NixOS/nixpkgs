{ stdenv, lib, fetchFromGitLab
, autoreconfHook, pkg-config, python3, addOpenGLRunpath
, libX11, libXext, xorgproto
}:

stdenv.mkDerivation rec {
  pname = "libglvnd";
  version = "1.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "glvnd";
    repo = "libglvnd";
    rev = "v${version}";
    sha256 = "sha256-yXSuG8UwD5KZbn4ysDStTdOGD4uHigjOhazlHT9ndNs=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config python3 addOpenGLRunpath ];
  buildInputs = [ libX11 libXext xorgproto ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/GLX/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/EGL/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/GLdispatch/Makefile.am \
      --replace "-Xlinker --version-script=$(VERSION_SCRIPT)" "-Xlinker"
  '';

  NIX_CFLAGS_COMPILE = toString ([
    "-UDEFAULT_EGL_VENDOR_CONFIG_DIRS"
    # FHS paths are added so that non-NixOS applications can find vendor files.
    "-DDEFAULT_EGL_VENDOR_CONFIG_DIRS=\"${addOpenGLRunpath.driverLink}/share/glvnd/egl_vendor.d:/etc/glvnd/egl_vendor.d:/usr/share/glvnd/egl_vendor.d\""

    "-Wno-error=array-bounds"
  ] ++ lib.optional stdenv.cc.isClang "-Wno-error");

  configureFlags  = []
    # Indirectly: https://bugs.freedesktop.org/show_bug.cgi?id=35268
    ++ lib.optional stdenv.hostPlatform.isMusl "--disable-tls"
    # Remove when aarch64-darwin asm support is upstream: https://gitlab.freedesktop.org/glvnd/libglvnd/-/issues/216
    ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) "--disable-asm";

  outputs = [ "out" "dev" ];

  # Set RUNPATH so that libGLX can find driver libraries in /run/opengl-driver(-32)/lib.
  # Note that libEGL does not need it because it uses driver config files which should
  # contain absolute paths to libraries.
  postFixup = ''
    addOpenGLRunpath $out/lib/libGLX.so
  '';

  passthru = { inherit (addOpenGLRunpath) driverLink; };

  meta = with lib; {
    description = "The GL Vendor-Neutral Dispatch library";
    longDescription = ''
      libglvnd is a vendor-neutral dispatch layer for arbitrating OpenGL API
      calls between multiple vendors. It allows multiple drivers from different
      vendors to coexist on the same filesystem, and determines which vendor to
      dispatch each API call to at runtime.
      Both GLX and EGL are supported, in any combination with OpenGL and OpenGL ES.
    '';
    inherit (src.meta) homepage;
    # https://gitlab.freedesktop.org/glvnd/libglvnd#libglvnd:
    changelog = "https://gitlab.freedesktop.org/glvnd/libglvnd/-/tags/v${version}";
    license = with licenses; [ mit bsd1 bsd3 gpl3Only asl20 ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ primeos ];
  };
}
