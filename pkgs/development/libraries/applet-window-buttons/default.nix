{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, extra-cmake-modules
, kcoreaddons
, kdeclarative
, kdecoration
, plasma-framework
}:

mkDerivation rec {
  pname = "applet-window-buttons";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "psifidotos";
    repo = "applet-window-buttons";
    rev = version;
    sha256 = "0r1h4kbdv6pxj15w4n1w50g8zsl0jrc4808dyfygzwf87mghziyz";
  };

  patches = [
    (fetchpatch {
      name = "fix-compilation-error-with-plasma-5.21.patch";
      url = "https://github.com/psifidotos/applet-window-buttons/commit/dc5ed862fa3cb943f9c0d561c864ff461156a19e.patch";
      sha256 = "17bdkkmy7k402viynj2bpw281qzsn0f1w8gf98gq65wkm4sf4j6k";
    })
  ];

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
