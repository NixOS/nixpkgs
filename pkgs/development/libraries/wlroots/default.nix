{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, wayland, libGL, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa
, libpng, ffmpeg_4, freerdp
}:

stdenv.mkDerivation rec {
  pname = "wlroots";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "wlroots";
    rev = version;
    sha256 = "1rdcmll5b8w242n6yfjpsaprq280ck2jmbz46dxndhignxgda7k4";
  };

  # $out for the library, $bin for rootston, and $examples for the example
  # programs (in examples) AND rootston
  outputs = [ "out" "bin" "examples" ];

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    wayland libGL wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa
    libpng ffmpeg_4 freerdp
  ];

  mesonFlags = [
    "-Dlibcap=enabled" "-Dlogind=enabled" "-Dxwayland=enabled" "-Dx11-backend=enabled"
    "-Dxcb-icccm=enabled" "-Dxcb-errors=enabled"
  ];

  postPatch = ''
    # It happens from time to time that the version wasn't updated:
    sed -iE "s/version: '[0-9]\.[0-9]\.[0-9]'/version: '${version}.0'/" meson.build
  '';

  postInstall = ''
    # Copy the library to $bin and $examples
    for output in "$bin" "$examples"; do
      mkdir -p $output/lib
      cp -P libwlroots* $output/lib/
    done
  '';

  postFixup = ''
    # Install rootston (the reference compositor) to $bin and $examples (this
    # has to be done after the fixup phase to prevent broken binaries):
    for output in "$bin" "$examples"; do
      mkdir -p $output/bin
      cp rootston/rootston $output/bin/
      patchelf \
        --set-rpath "$(patchelf --print-rpath $output/bin/rootston | sed s,$out,$output,g)" \
        $output/bin/rootston
      mkdir $output/etc
      cp ../rootston/rootston.ini.example $output/etc/rootston.ini
    done
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
      patchelf \
        --set-rpath "$(patchelf --print-rpath $output/bin/rootston | sed s,$out,$examples,g)" \
        "$examples/bin/wlroots-$binary"
    done
  '';

  meta = with stdenv.lib; {
    description = "A modular Wayland compositor library";
    inherit (src.meta) homepage;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
