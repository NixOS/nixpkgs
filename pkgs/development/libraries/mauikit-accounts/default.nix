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
  pname = "mauikit-accounts";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit-accounts";
    rev = "v${version}";
    sha256 = "sha256-B0VmgE0L8kBOqR/lrWCHO3psCQ7GZVPIGljGAwpuymE=";
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
    homepage = "https://invent.kde.org/maui/mauikit-accounts";
    description = "MauiKit utilities to handle User Accounts";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ onny ];
  };
}
