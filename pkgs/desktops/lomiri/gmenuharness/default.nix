{ mkDerivation, lib, fetchFromGitHub
, cmake, cmake-extras
, glib, unity-api, qtbase, libqtdbustest
}:

mkDerivation rec {
  pname = "gmenuharness-unstable";
  version = "2020-05-17";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "gmenuharness";
    rev = "c7242648fa0a85b6ff810db8676deb7e51974182";
    sha256 = "1m7mf2rx7rsw0ipyjkq0m5cm5hzd2g7hkyhj7grn3cfymvg9avnl";
  };

  nativeBuildInputs = [ cmake cmake-extras ];

  buildInputs = [ glib unity-api qtbase libqtdbustest ];

  meta = with lib; {
    description = "GMenu harness library";
    longDescription = ''
      This is a library to test GMenuModel structures.
    '';
    homepage = "https://launchpad.net/gmenuharness";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
