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
  version = "1.2.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit-filebrowsing";
    rev = "v${version}";
    sha256 = "1m56lil7w884wn8qycl7y55abvw2vanfy8c4g786200p6acsh3kl";
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
