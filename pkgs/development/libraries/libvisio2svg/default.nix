{ lib
, stdenv
, fetchFromGitHub
, cmake
, freetype
, libemf2svg
, librevenge
, libvisio
, libwmf
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "libvisio2svg";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "kakwa";
    repo = pname;
    rev = version;
    sha256 = "14m37mmib1596c76j9w178jqhwxyih2sy5w5q9xglh8cmlfn1hfx";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libxml2 freetype librevenge libvisio libwmf libemf2svg ];

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  meta = with lib; {
    description = "Library and tools to convert Microsoft Visio documents (VSS and VSD) to SVG";
    homepage = "https://github.com/kakwa/libvisio2svg";
    maintainers = with maintainers; [ erdnaxe ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
