{ plasmaPackage, extra-cmake-modules, kcmutils, kcrash, kdeclarative
, kdelibs4support, kdoctools, kglobalaccel, kidletime, kwayland
, libXcursor, pam, plasma-framework, qtdeclarative, wayland
}:

plasmaPackage {
  name = "kscreenlocker";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcmutils kcrash kdelibs4support kglobalaccel kidletime kwayland
    libXcursor pam wayland
  ];
  propagatedBuildInputs = [
    kdeclarative plasma-framework qtdeclarative
  ];
}
