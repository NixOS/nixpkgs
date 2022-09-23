{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, kcoreaddons
, kdeclarative
, kdecoration
, plasma-framework
}:

mkDerivation rec {
  pname = "applet-window-buttons";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "psifidotos";
    repo = "applet-window-buttons";
    rev = version;
    hash = "sha256-Qww/22bEmjuq+R3o0UDcS6U+34qjaeSEy+g681/hcfE=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcoreaddons
    kdeclarative
    kdecoration
    plasma-framework
  ];

  meta = with lib; {
    description = "Plasma 5 applet in order to show window buttons in your panels";
    homepage = "https://github.com/psifidotos/applet-window-buttons";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
