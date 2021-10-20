{ lib, stdenv
, cmake, fetchFromGitHub, extra-cmake-modules
, qtbase, wrapQtAppsHook, ki18n, kdelibs4support, krunner
}:

stdenv.mkDerivation rec {
  pname = "krunner-symbols";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "domschrei";
    repo = "krunner-symbols";
    rev = version;
    sha256 = "sha256-YsoZdPTWpk3/YERwerrVEcaf2IfGVJwpq32onhP8Exo=";
  };

  buildInputs = [ qtbase ki18n kdelibs4support krunner ];
  nativeBuildInputs = [ cmake wrapQtAppsHook extra-cmake-modules ];

  postPatch = ''
    # symbols.cpp hardcodes the location of configuration files
    substituteInPlace symbols.cpp \
      --replace "/usr/share/config/krunner-symbol" "$out/share/config/krunner-symbol"

    # change cmake flag names to output using the correct qt-plugin prefix and kservice location
    substituteInPlace CMakeLists.txt \
      --replace "LOCATION_PLUGIN" "KDE_INSTALL_PLUGINDIR" \
      --replace "LOCATION_DESKTOP" "KDE_INSTALL_KSERVICES5DIR"
  '';

  cmakeFlags = [ "-DLOCATION_CONFIG=share/config" ];

  meta = with lib; {
    description = "A little krunner plugin (Plasma 5) to retrieve unicode symbols, or any other string, based on a corresponding keyword";
    homepage = "https://github.com/domschrei/krunner-symbols";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hqurve ];
    platforms = platforms.linux;
  };
}
