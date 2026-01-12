{
  lib,
  stdenv,
  fetchurl,
  cmake,
  qtbase,
  extra-cmake-modules,
}:

stdenv.mkDerivation rec {
  pname = "libqaccessibilityclient";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://kde/stable/libqaccessibilityclient/libqaccessibilityclient-${version}.tar.xz";
    hash = "sha256-TFDESGItycUEHtENp9h7Pk5xzLSdSDGoSSEdQjxfXTM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [ qtbase ];
  cmakeFlags = [ "-DQT_MAJOR_VERSION=${lib.versions.major qtbase.version}" ];

  outputs = [
    "out"
    "dev"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Accessibilty tools helper library, used e.g. by screen readers";
    homepage = "https://github.com/KDE/libqaccessibilityclient";
    maintainers = with lib.maintainers; [ artturin ];
    license = with lib.licenses; [
      lgpl3Only # or
      lgpl21Only
    ];
    platforms = lib.platforms.linux;
  };
}
