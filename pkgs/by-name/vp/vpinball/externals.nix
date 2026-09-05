{
  lib,
  stdenv,
  autoconf,
  automake,
  bison,
  cmake,
  libtool,
  nasm,
  patchelf,
  perl,
  pkg-config,
  alsa-lib,
  dbus,
  freetype,
  harfbuzz,
  libGL,
  libdrm,
  libjpeg,
  libpng,
  libpulseaudio,
  libtiff,
  libusb1,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxtst,
  libxcb,
  libxkbcommon,
  systemd,
  wayland,
  wayland-protocols,
  zlib,
  sources,
}:

let
  runtimeLibraryPath = lib.makeLibraryPath [
    alsa-lib
    dbus
    freetype
    harfbuzz
    libGL
    libdrm
    libjpeg
    libpng
    libpulseaudio
    libtiff
    libusb1
    libx11
    libxcursor
    libxext
    libxi
    libxrandr
    libxrender
    libxscrnsaver
    libxtst
    libxcb
    libxkbcommon
    systemd
    wayland
    zlib
  ];
in
stdenv.mkDerivation {
  pname = "vpinball-externals";
  version = "10.8.1-unstable-2026-06-15";

  dontUnpack = true;
  dontConfigure = true;

  nativeBuildInputs = [
    autoconf
    automake
    bison
    cmake
    libtool
    nasm
    patchelf
    perl
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    dbus
    freetype
    harfbuzz
    libGL
    libdrm
    libjpeg
    libpng
    libpulseaudio
    libtiff
    libusb1
    libx11
    libxcursor
    libxext
    libxi
    libxrandr
    libxrender
    libxscrnsaver
    libxtst
    libxcb
    libxkbcommon
    systemd
    wayland
    wayland-protocols
    zlib
  ];

  buildPhase = ''
    runHook preBuild

    cp -R --no-preserve=mode ${sources.sdl} SDL
    cp -R --no-preserve=mode ${sources.sdl-image} SDL_image
    cp -R --no-preserve=mode ${sources.sdl-ttf} SDL_ttf
    cp -R --no-preserve=mode ${sources.freeimage} freeimage
    tar xzf ${sources.bgfx-cmake}
    cp -R --no-preserve=mode ${sources.bgfx} bgfx-patched
    rm -rf bgfx.cmake/bgfx
    mv bgfx-patched bgfx.cmake/bgfx
    cp -R --no-preserve=mode ${sources.pinmame} pinmame
    cp -R --no-preserve=mode ${sources.libaltsound} libaltsound
    cp -R --no-preserve=mode ${sources.ffmpeg} ffmpeg
    cp -R --no-preserve=mode ${sources.libzip} libzip
    cp -R --no-preserve=mode ${sources.libwinevbs} libwinevbs
    cp -R --no-preserve=mode ${sources.libdof} libdof
    cp -R --no-preserve=mode ${sources.libdof-libusb} libdof-libusb
    cp -R --no-preserve=mode ${sources.libdof-libserialport} libdof-libserialport
    cp -R --no-preserve=mode ${sources.libdof-hidapi} libdof-hidapi
    cp -R --no-preserve=mode ${sources.libdof-libftdi} libdof-libftdi
    cp -R --no-preserve=mode ${sources.libdmdutil} libdmdutil
    cp -R --no-preserve=mode ${sources.libdmdutil-libzedmd} libzedmd
    cp -R --no-preserve=mode ${sources.libdmdutil-libserum} libserum
    cp -R --no-preserve=mode ${sources.libdmdutil-libpupdmd} libpupdmd
    cp -R --no-preserve=mode ${sources.libdmdutil-libvni} libvni
    cp -R --no-preserve=mode ${sources.libdmdutil-cargs} cargs
    cp -R --no-preserve=mode ${sources.libdmdutil-libframeutil} libframeutil
    cp -R --no-preserve=mode ${sources.libdmdutil-sockpp} sockpp

    cmake -S SDL -B SDL/build \
      -DSDL_SHARED=ON \
      -DSDL_STATIC=OFF \
      -DSDL_TEST_LIBRARY=OFF \
      -DSDL_OPENGLES=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build SDL/build --parallel "$NIX_BUILD_CORES"

    cmake -S SDL_image -B SDL_image/build \
      -DBUILD_SHARED_LIBS=ON \
      -DSDLIMAGE_SAMPLES=OFF \
      -DSDLIMAGE_DEPS_SHARED=ON \
      -DSDLIMAGE_VENDORED=OFF \
      -DSDLIMAGE_AVIF=OFF \
      -DSDLIMAGE_WEBP=OFF \
      -DSDLIMAGE_JXL=OFF \
      -DSDL3_DIR="$PWD/SDL/build" \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build SDL_image/build --parallel "$NIX_BUILD_CORES"

    cmake -S SDL_ttf -B SDL_ttf/build \
      -DBUILD_SHARED_LIBS=ON \
      -DSDLTTF_SAMPLES=OFF \
      -DSDLTTF_VENDORED=OFF \
      -DSDLTTF_HARFBUZZ=ON \
      -DSDL3_DIR="$PWD/SDL/build" \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build SDL_ttf/build --parallel "$NIX_BUILD_CORES"

    cmake -S freeimage -B freeimage/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DBUILD_STATIC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build freeimage/build --parallel "$NIX_BUILD_CORES"

    cmake -S bgfx.cmake -B bgfx.cmake/build \
      -DBGFX_LIBRARY_TYPE=SHARED \
      -DBGFX_BUILD_TOOLS=OFF \
      -DBGFX_BUILD_EXAMPLES=OFF \
      -DBGFX_CONFIG_MULTITHREADED=ON \
      -DBGFX_CONFIG_MAX_FRAME_BUFFERS=256 \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build bgfx.cmake/build --parallel "$NIX_BUILD_CORES"

    cp pinmame/cmake/libpinmame/CMakeLists.txt pinmame/CMakeLists.txt
    cmake -S pinmame -B pinmame/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DBUILD_STATIC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build pinmame/build --parallel "$NIX_BUILD_CORES"

    cmake -S libaltsound -B libaltsound/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DBUILD_STATIC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libaltsound/build --parallel "$NIX_BUILD_CORES"

    find ffmpeg -name '*.sh' -exec chmod +x {} +
    chmod +x ffmpeg/configure
    (cd ffmpeg && \
      LDFLAGS=-Wl,-rpath,'$$$$ORIGIN' bash ./configure \
        --enable-shared \
        --disable-static \
        --disable-programs \
        --disable-doc && \
      make -j"$NIX_BUILD_CORES")

    cmake -S libzip -B libzip/build \
      -DBUILD_SHARED_LIBS=ON \
      -DENABLE_ZSTD=OFF \
      -DENABLE_BZIP2=OFF \
      -DENABLE_LZMA=OFF \
      -DBUILD_TOOLS=OFF \
      -DBUILD_REGRESS=OFF \
      -DBUILD_OSSFUZZ=OFF \
      -DBUILD_EXAMPLES=OFF \
      -DBUILD_DOC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libzip/build --parallel "$NIX_BUILD_CORES"

    perl -0pi -e '
      s{(^set\(LIBWINEVBS_COMPILE_OPTIONS\s*\n(?![^)]*-Wno-error=format-security)\s*-Wno-format)}{$1\n   -Wno-error=format-security}m;
    ' libwinevbs/CMakeLists.txt
    cmake -S libwinevbs -B libwinevbs/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libwinevbs/build --parallel "$NIX_BUILD_CORES"

    mkdir -p \
      libdof/third-party/include/libusb-1.0 \
      libdof/third-party/build-libs/linux/x64 \
      libdof/third-party/runtime-libs/linux/x64

    (cd libdof-libusb && \
      find . -name '*.sh' -exec chmod +x {} + && \
      ./autogen.sh && \
      chmod +x configure && \
      ./configure --enable-shared && \
      make -j"$NIX_BUILD_CORES")
    cp libdof-libusb/libusb/libusb.h libdof/third-party/include/libusb-1.0/
    cp -a libdof-libusb/libusb/.libs/libusb-1.0.so* libdof/third-party/runtime-libs/linux/x64/

    (cd libdof-libserialport && \
      find . -name '*.sh' -exec chmod +x {} + && \
      ./autogen.sh && \
      chmod +x configure && \
      ./configure && \
      make -j"$NIX_BUILD_CORES")
    cp libdof-libserialport/libserialport.h libdof/third-party/include/
    cp libdof-libserialport/.libs/libserialport.a libdof/third-party/build-libs/linux/x64/
    cp -a libdof-libserialport/.libs/libserialport.so* libdof/third-party/runtime-libs/linux/x64/

    cmake -S libdof-hidapi -B libdof-hidapi/build \
      -DHIDAPI_WITH_LIBUSB=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libdof-hidapi/build --parallel "$NIX_BUILD_CORES"
    cp -r libdof-hidapi/hidapi libdof/third-party/include/
    cp -a libdof-hidapi/build/src/linux/libhidapi-hidraw.so* libdof/third-party/runtime-libs/linux/x64/

    perl -0pi -e 's{cmake_minimum_required\([^)]*\)}{cmake_minimum_required(VERSION 3.10)}' libdof-libftdi/CMakeLists.txt
    cmake -S libdof-libftdi -B libdof-libftdi/build \
      -DFTDI_EEPROM=OFF \
      -DEXAMPLES=OFF \
      -DSTATICLIBS=OFF \
      -DLIBUSB_INCLUDE_DIR="$PWD/libdof-libusb/libusb" \
      -DLIBUSB_LIBRARIES="$PWD/libdof-libusb/libusb/.libs/libusb-1.0.so" \
      -DCMAKE_INSTALL_RPATH='\$ORIGIN' \
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libdof-libftdi/build --parallel "$NIX_BUILD_CORES"
    mkdir -p libdof/third-party/include/libftdi1
    cp libdof-libftdi/src/ftdi.h libdof/third-party/include/libftdi1/
    cp -a libdof-libftdi/build/src/libftdi1.so* libdof/third-party/runtime-libs/linux/x64/

    cmake -S libdof -B libdof/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DBUILD_STATIC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libdof/build --parallel "$NIX_BUILD_CORES"

    mkdir -p \
      libzedmd/third-party/include \
      libzedmd/third-party/build-libs/linux/x64 \
      libzedmd/third-party/runtime-libs/linux/x64

    cmake -S cargs -B cargs/build \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build cargs/build --parallel "$NIX_BUILD_CORES"
    cp cargs/include/cargs.h libzedmd/third-party/include/
    cp cargs/build/libcargs.so* libzedmd/third-party/runtime-libs/linux/x64/

    cp libdof-libserialport/libserialport.h libzedmd/third-party/include/
    cp libdof-libserialport/.libs/libserialport.a libzedmd/third-party/build-libs/linux/x64/
    cp -a libdof-libserialport/.libs/libserialport.so* libzedmd/third-party/runtime-libs/linux/x64/

    cp libframeutil/include/* libzedmd/third-party/include/

    cmake -S sockpp -B sockpp/build \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build sockpp/build --parallel "$NIX_BUILD_CORES"
    cp -r sockpp/include/sockpp libzedmd/third-party/include/
    cp -a sockpp/build/libsockpp.so* libzedmd/third-party/runtime-libs/linux/x64/

    cmake -S libzedmd -B libzedmd/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DBUILD_SHARED=ON \
      -DBUILD_STATIC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libzedmd/build --parallel "$NIX_BUILD_CORES"

    mkdir -p \
      libdmdutil/third-party/include/libusb-1.0 \
      libdmdutil/third-party/build-libs/linux/x64 \
      libdmdutil/third-party/runtime-libs/linux/x64

    cp libdof-libusb/libusb/libusb.h libdmdutil/third-party/include/libusb-1.0/
    cp -a libdof-libusb/libusb/.libs/libusb-1.0.so* libdmdutil/third-party/runtime-libs/linux/x64/

    cp libzedmd/src/ZeDMD.h libdmdutil/third-party/include/
    cp libzedmd/third-party/include/libserialport.h libdmdutil/third-party/include/
    cp libzedmd/third-party/include/cargs.h libdmdutil/third-party/include/
    cp -r libzedmd/third-party/include/komihash libdmdutil/third-party/include/
    cp -r libzedmd/third-party/include/sockpp libdmdutil/third-party/include/
    cp libzedmd/third-party/include/FrameUtil.h libdmdutil/third-party/include/
    cp libzedmd/third-party/runtime-libs/linux/x64/libcargs.so* libdmdutil/third-party/runtime-libs/linux/x64/
    cp -a libzedmd/third-party/runtime-libs/linux/x64/libserialport.so* libdmdutil/third-party/runtime-libs/linux/x64/
    cp -a libzedmd/third-party/runtime-libs/linux/x64/libsockpp.so* libdmdutil/third-party/runtime-libs/linux/x64/
    cp -a libzedmd/build/libzedmd.so* libdmdutil/third-party/runtime-libs/linux/x64/

    cmake -S libserum -B libserum/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DBUILD_SHARED=ON \
      -DBUILD_STATIC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libserum/build --parallel "$NIX_BUILD_CORES"
    cp -r libserum/third-party/include/lz4 libdmdutil/third-party/include/
    cp libserum/src/LZ4Stream.h libdmdutil/third-party/include/
    cp libserum/src/SceneGenerator.h libdmdutil/third-party/include/
    cp libserum/src/serum.h libdmdutil/third-party/include/
    cp libserum/src/TimeUtils.h libdmdutil/third-party/include/
    cp libserum/src/serum-decode.h libdmdutil/third-party/include/
    cp -a libserum/build/libserum.so* libdmdutil/third-party/runtime-libs/linux/x64/

    cmake -S libpupdmd -B libpupdmd/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DBUILD_SHARED=ON \
      -DBUILD_STATIC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libpupdmd/build --parallel "$NIX_BUILD_CORES"
    cp libpupdmd/src/pupdmd.h libdmdutil/third-party/include/
    cp -a libpupdmd/build/libpupdmd.so* libdmdutil/third-party/runtime-libs/linux/x64/

    mkdir -p libvni/third-party/include
    cp libframeutil/include/* libvni/third-party/include/
    cmake -S libvni -B libvni/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DBUILD_SHARED=ON \
      -DBUILD_STATIC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libvni/build --parallel "$NIX_BUILD_CORES"
    cp libvni/src/vni.h libdmdutil/third-party/include/
    cp -a libvni/build/libvni.so* libdmdutil/third-party/runtime-libs/linux/x64/

    cmake -S libdmdutil -B libdmdutil/build \
      -DPLATFORM=linux \
      -DARCH=x64 \
      -DBUILD_STATIC=OFF \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libdmdutil/build --parallel "$NIX_BUILD_CORES"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/third-party/include" "$out/third-party/runtime-libs/linux-x64"

    cp -a SDL/build/libSDL3.so* "$out/third-party/runtime-libs/linux-x64/"
    cp -r SDL/include/SDL3 "$out/third-party/include/"

    cp -a SDL_image/build/libSDL3_image.so* "$out/third-party/runtime-libs/linux-x64/"
    cp -r SDL_image/include/SDL3_image "$out/third-party/include/"

    cp -a SDL_ttf/build/libSDL3_ttf.so* "$out/third-party/runtime-libs/linux-x64/"
    cp -r SDL_ttf/include/SDL3_ttf "$out/third-party/include/"

    cp -a freeimage/build/libfreeimage.so* "$out/third-party/runtime-libs/linux-x64/"
    cp freeimage/Source/FreeImage.h "$out/third-party/include/"

    cp -a bgfx.cmake/build/cmake/bgfx/libbgfx.so* "$out/third-party/runtime-libs/linux-x64/"
    cp -r bgfx.cmake/bgfx/include/bgfx "$out/third-party/include/"
    cp -r bgfx.cmake/bimg/include/bimg "$out/third-party/include/"
    cp -r bgfx.cmake/bx/include/bx "$out/third-party/include/"

    cp -a pinmame/build/libpinmame.so* "$out/third-party/runtime-libs/linux-x64/"
    cp pinmame/src/libpinmame/libpinmame.h "$out/third-party/include/"

    cp -a libaltsound/build/libaltsound.so* "$out/third-party/runtime-libs/linux-x64/"
    cp libaltsound/src/altsound.h "$out/third-party/include/"

    for ffmpegLibrary in libavcodec libavdevice libavfilter libavformat libavutil libswresample libswscale; do
      cp -a "ffmpeg/$ffmpegLibrary/$ffmpegLibrary".so* "$out/third-party/runtime-libs/linux-x64/"
      mkdir -p "$out/third-party/include/$ffmpegLibrary"
      cp "ffmpeg/$ffmpegLibrary"/*.h "$out/third-party/include/$ffmpegLibrary/"
    done

    cp -a libzip/build/lib/libzip.so* "$out/third-party/runtime-libs/linux-x64/"
    cp libzip/build/zipconf.h "$out/third-party/include/"
    cp libzip/lib/zip.h "$out/third-party/include/"

    cp -a libwinevbs/build/libwinevbs.so* "$out/third-party/runtime-libs/linux-x64/"
    mkdir -p \
      "$out/third-party/include/libwinevbs/wine/include" \
      "$out/third-party/include/libwinevbs/atl/include" \
      "$out/third-party/include/libwinevbs/atlmfc/include"
    cp libwinevbs/include/libwinevbs.h "$out/third-party/include/libwinevbs/"
    cp -r libwinevbs/wine/include/. "$out/third-party/include/libwinevbs/wine/include/"
    cp -r libwinevbs/atl/include/. "$out/third-party/include/libwinevbs/atl/include/"
    cp -r libwinevbs/atlmfc/include/. "$out/third-party/include/libwinevbs/atlmfc/include/"

    cp -a libdof/build/libdof.so* "$out/third-party/runtime-libs/linux-x64/"
    cp -r libdof/include/DOF "$out/third-party/include/"
    cp -a libdof/third-party/runtime-libs/linux/x64/libusb*.so* "$out/third-party/runtime-libs/linux-x64/"
    cp -a libdof/third-party/runtime-libs/linux/x64/libserialport*.so* "$out/third-party/runtime-libs/linux-x64/"
    cp -a libdof/third-party/runtime-libs/linux/x64/libhidapi-hidraw.so* "$out/third-party/runtime-libs/linux-x64/"
    cp -a libdof/third-party/runtime-libs/linux/x64/libftdi1*.so* "$out/third-party/runtime-libs/linux-x64/"

    cp -a libdmdutil/build/libdmdutil.so* "$out/third-party/runtime-libs/linux-x64/"
    cp -r libdmdutil/include/DMDUtil "$out/third-party/include/"
    cp -a libdmdutil/third-party/runtime-libs/linux/x64/libzedmd.so* "$out/third-party/runtime-libs/linux-x64/"
    cp libdmdutil/third-party/include/ZeDMD.h "$out/third-party/include/"
    cp -a libdmdutil/third-party/runtime-libs/linux/x64/libserum.so* "$out/third-party/runtime-libs/linux-x64/"
    cp libdmdutil/third-party/include/serum.h "$out/third-party/include/"
    cp libdmdutil/third-party/include/serum-decode.h "$out/third-party/include/"
    cp -a libdmdutil/third-party/runtime-libs/linux/x64/libpupdmd.so* "$out/third-party/runtime-libs/linux-x64/"
    cp libdmdutil/third-party/include/pupdmd.h "$out/third-party/include/"
    cp -a libdmdutil/third-party/runtime-libs/linux/x64/libsockpp.so* "$out/third-party/runtime-libs/linux-x64/"
    cp libdmdutil/third-party/runtime-libs/linux/x64/libcargs.so "$out/third-party/runtime-libs/linux-x64/"
    cp libdmdutil/third-party/include/vni.h "$out/third-party/include/"
    cp -a libdmdutil/third-party/runtime-libs/linux/x64/libvni.so* "$out/third-party/runtime-libs/linux-x64/"

    for library in "$out"/third-party/runtime-libs/linux-x64/*.so*; do
      if [ -f "$library" ]; then
        patchelf --set-rpath "\$ORIGIN:${runtimeLibraryPath}" "$library"
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Visual Pinball third-party dependency bundle for Linux x64";
    license = with lib.licenses; [
      gpl3Plus
      unfreeRedistributable
    ];
    platforms = [ "x86_64-linux" ];
    # The bundle combines dependencies with different licenses. Track these
    # precisely as the individual build blocks are ported.
  };
}
