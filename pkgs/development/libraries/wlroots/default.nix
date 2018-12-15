{ stdenv, fetchFromGitHub, fetchpatch, meson, ninja, pkgconfig
, wayland, libGL, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa_noglu
, libpng, ffmpeg_4
, python3Packages # TODO: Temporary
}:

let
  pname = "wlroots";
  version = "0.2";
  meson480 = meson.overrideAttrs (oldAttrs: rec {
    name = pname + "-" + version;
    pname = "meson";
    version = "0.48.0";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0qawsm6px1vca3babnqwn0hmkzsxy4w0gi345apd2qk3v0cv7ipc";
    };
    # Remove gir-fallback-path.patch and
    # a87496addd9160300837aa50193f4798c6f1d251.patch (already in 0.48.0):
    patches = builtins.filter
      (str: !(stdenv.lib.hasSuffix "gir-fallback-path.patch" str
              || stdenv.lib.hasSuffix "a87496addd9160300837aa50193f4798c6f1d251.patch" str))
      oldAttrs.patches;
  });
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "wlroots";
    rev = version;
    sha256 = "0gfxawjlb736xl90zfv3n6zzf5n1cacgzflqi1zq1wn7wd3j6ppv";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace "version: '0.1.0'" "version: '${version}.0'"
  '';

  # $out for the library, $bin for rootston, and $examples for the example
  # programs (in examples) AND rootston
  outputs = [ "out" "bin" "examples" ];

  nativeBuildInputs = [ meson480 ninja pkgconfig ];

  buildInputs = [
    wayland libGL wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa_noglu
    libpng ffmpeg_4
  ];

  mesonFlags = [
    "-Dlibcap=enabled" "-Dlogind=enabled" "-Dxwayland=enabled" "-Dx11-backend=enabled"
    "-Dxcb-icccm=enabled" "-Dxcb-errors=enabled"
  ];

  postInstall = ''
    # Install rootston (the reference compositor) to $bin and $examples
    for output in "$bin" "$examples"; do
      mkdir -p $output/bin
      cp rootston/rootston $output/bin/
      mkdir $output/lib
      cp libwlroots* $output/lib/
      patchelf \
        --set-rpath "$output/lib:${stdenv.lib.makeLibraryPath buildInputs}" \
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
      patchelf \
        --set-rpath "$examples/lib:${stdenv.lib.makeLibraryPath buildInputs}" \
        "$binary"
      cp "$binary" "$examples/bin/wlroots-$binary"
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
