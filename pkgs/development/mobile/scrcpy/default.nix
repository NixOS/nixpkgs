{ stdenv, fetchFromGitHub, fetchurl, meson, ninja, pkgconfig, SDL2, libav }:

stdenv.mkDerivation rec {
  name = "scrcpy-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = "scrcpy";
    rev = "v${version}";
    sha256 = "01zw6h6mz2cwqfh9lwypm8pbfx9m9df91l1fq1i0f1d8v49x8wqc";
  };

  server = fetchurl {
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}.jar";
    sha256 = "cb39654ed2fda3d30ddff292806950ccc5c394375ea12b974f790c7f38f61f60";
  };

  mesonFlags = [ "-Dprebuilt_server=${server}" ];

  buildInputs = [ meson ninja pkgconfig SDL2 libav ];

  meta = with stdenv.lib; {
    description = "Display and control your Android device";
    homepage = https://github.com/Genymobile/scrcpy;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ deltaevo ];
  };
}
