{ mkDerivation, lib, fetchFromGitHub, fetchpatch, cmake, pkg-config, intltool, qtbase, qtdeclarative, upower, accountsservice_0642, geonames, click, gsettings-qt, gtk3, gnome3, trust-store, libqtdbusmock, libqtdbustest, xvfb_run, polkit
}:

mkDerivation rec {
  pname = "system-settings-unstable";
  version = "2020-12-08";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "system-settings";
    rev = "3d579015d321a880810d73755c823e28ff2fdfed";
    sha256 = "0r6y4jzwqbahv6s152zb6h13xdg7bpv908x0icrbag2rv1g14m1b";
  };

  patches = [
    (fetchpatch {
      name = "system-settings_Make_apt-pkg_optional.patch";
      url = "https://gitlab.manjaro.org/manjaro-arm/packages/community/lomiri-dev/system-settings-git/-/raw/729c48e5ddbb6e47a5259fc3ec7af11ff154aa83/no-deb-system-updates.patch";
      sha256 = "1sjrvr14dzp1f7nhmv74gm6vjc6ky194qradyhwsf0adv21fg0wl";
    })
    ./0001-Make_apt-pkg_optional_in_tests.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$''\{CMAKE_INSTALL_PREFIX}/$''\{LIBDIR}' '$''\{LIBDIR}'
  '';

  nativeBuildInputs = [ cmake pkg-config intltool ];

  buildInputs = [ qtbase qtdeclarative upower accountsservice_0642 geonames click gsettings-qt gtk3 gnome3.gnome-desktop.dev trust-store libqtdbusmock libqtdbustest xvfb_run polkit ];

  meta = with lib; {
    description = "System Settings application for Ubuntu Touch";
    longDescription = ''
      This package contains the System Settings application used on the
      Ubuntu Touch images, it's designed for phones, tablets and convergent
      devices.
    '';
    homepage = "https://launchpad.net/ubuntu-system-settings";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
