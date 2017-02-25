{
  plasmaPackage,
  ecm, kdoctools,
  kcmutils, kcrash, kdeclarative, kdelibs4support, kglobalaccel, kidletime,
  kwayland, libXcursor, pam, plasma-framework, qtdeclarative, wayland
}:

plasmaPackage {
  name = "kscreenlocker";
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kcmutils kcrash kdeclarative kdelibs4support kglobalaccel kidletime kwayland
    libXcursor pam plasma-framework qtdeclarative wayland
  ];
}
