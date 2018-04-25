{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules,
  qtbase, kconfig, kcoreaddons, kwidgetsaddons, kguiaddons,
  qttools
}:

mkDerivation rec {
  pname = "kproperty";
  version = "3.1.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "18qlwp7ajpx16bd0lfzqfx8y9cbrs8k4nax3cr30wj5sd3l8xpky";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ kconfig kcoreaddons kwidgetsaddons kguiaddons qttools ];

  propagatedBuildInputs = [ qtbase ];

  meta = with lib; {
    description = "A property editing framework with editor widget similar to what is known from Qt Designer";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
