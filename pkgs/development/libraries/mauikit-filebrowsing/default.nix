{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kconfig
, kio
, mauikit
}:

mkDerivation rec {
  pname = "mauikit-filebrowsing";
  version = "2.0.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit-filebrowsing";
    rev = "v${version}";
    sha256 = "sha256-hiR0RbZTduH0noyzpewsNJAtSdCtiSmTP8SLMBgK3uA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kio
    mauikit
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-filebrowsing";
    description = "MauiKit File Browsing utilities and controls";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
