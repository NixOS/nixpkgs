{ plasmaPackage
, ecm
}:

plasmaPackage {
  name = "breeze-gtk";
  nativeBuildInputs = [ ecm ];
  cmakeFlags = [ "-DWITH_GTK3_VERSION=3.20" ];
}
