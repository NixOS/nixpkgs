{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kconfig
, kio
, mauikit
, syntax-highlighting
}:

mkDerivation rec {
  pname = "mauikit-texteditor";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit-texteditor";
    rev = "v${version}";
    sha256 = "sha256-C0EOc0CE6Ef7vnmOKRqTzeJUamGXsvREpHRPGTcAaIc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kio
    mauikit
    syntax-highlighting
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-texteditor";
    description = "MauiKit Text Editor components";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ onny ];
  };
}
