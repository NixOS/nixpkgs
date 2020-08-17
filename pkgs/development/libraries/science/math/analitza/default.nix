{ stdenv
, fetchurl
, mkDerivation
# native
, cmake
, extra-cmake-modules
, kdoctools
, qttools
# not native
, eigen
, qtbase
}:

mkDerivation rec {
  pname = "analitza";
  version = "20.08.0";

  src = fetchurl {
    url = "https://download.kde.org/stable/release-service/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "18as819f5yi2gk1v42smhvil9vk6m254amqfcvszqmz5676mxg2i";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    kdoctools
    qttools
  ];
  buildInputs = [
    eigen
    qtbase
  ];
  outputs = [ "out" "dev" ];
  doCheck = true;
  # Disable failing tests - due to Xorg not available
  preConfigure = ''
    sed -i '/add_subdirectory(tests)/d' analitzaplot/CMakeLists.txt
  '';
  # Make tests succeed
  preCheck = ''
    export LD_LIBRARY_PATH="$(pwd)/analitza:$(pwd)/analitzagui:$(pwd)/analitzaplot:$(pwd)/analitzawidgets:$(pwd)/declarative''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';

  meta = with stdenv.lib; {
    license = with stdenv.lib.licenses; [ gpl2 lgpl21 fdl12 ];
    homepage = "https://github.com/KDE/analitza";
    description = "Application for interactive graphing and analysis of scientific data";
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
