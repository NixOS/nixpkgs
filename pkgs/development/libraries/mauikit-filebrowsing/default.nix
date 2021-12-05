{ lib, mkDerivation, fetchFromGitLab, cmake, extra-cmake-modules, kconfig, kio
, mauikit }:

mkDerivation rec {
  pname = "mauikit-filebrowsing";
  version = "2.1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit-filebrowsing";
    rev = "v${version}";
    sha256 = "sha256-j6VoNtMkDB5BSET/RUiQlWdL0D1dAHlW929WNCDC+PE=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ kconfig kio mauikit ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-filebrowsing";
    description = "MauiKit File Browsing utilities and controls";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
