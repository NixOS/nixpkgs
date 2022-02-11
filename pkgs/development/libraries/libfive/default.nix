{ lib
, mkDerivation
, wrapQtAppsHook
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, eigen
, zlib
, libpng
, boost
, guile
, stdenv
}:

mkDerivation {
  pname = "libfive-unstable";
  version = "2020-02-15";

  src = fetchFromGitHub {
    owner = "libfive";
    repo = "libfive";
    rev = "5b7717a25064478cd6bdb190683566eaf4c7afdd";
    sha256 = "102zw2n3vzv84i323is4qrwwqqha8v1cniw54ss8f4bq6dmic0bg";
  };

  nativeBuildInputs = [ wrapQtAppsHook cmake ninja pkg-config ];
  buildInputs = [ eigen zlib libpng boost guile ];

  postInstall = if stdenv.isDarwin then ''
    # No rules to install the mac app, so do it manually.
    mkdir -p $out/Applications
    cp -r studio/Studio.app $out/Applications/Studio.app

    install_name_tool \
      -change libfive.dylib $out/lib/libfive.dylib \
      -change libfive-guile.dylib $out/lib/libfive-guile.dylib \
      $out/Applications/Studio.app/Contents/MacOS/Studio
  '' else ''
    # Link "Studio" binary to "libfive-studio" to be more obvious:
    ln -s "$out/bin/Studio" "$out/bin/libfive-studio"
  '';

  meta = with lib; {
    description = "Infrastructure for solid modeling with F-Reps in C, C++, and Guile";
    homepage = "https://libfive.com/";
    maintainers = with maintainers; [ hodapp kovirobi ];
    license = with licenses; [ mpl20 gpl2Plus ];
    platforms = with platforms; linux ++ darwin;
  };
}
