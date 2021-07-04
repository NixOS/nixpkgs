{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, substituteAll
, networkmanager
, pkgs
, ncurses
, xdg-utils
, proton-client
, pyxdg
, keyring
, pygobject3
, jinja2
, distro
, systemd
}:

buildPythonPackage rec {
  pname = "protonvpn-nm-lib";
  version = "3.3.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "protonvpn-nm-lib";
    rev = version;
    sha256 = "1izb9bnvdw36iwmg7mlm7706pk8jg74qh9mcjwvl7vsfvn92jc4j";
  };

  patches = [
    # Patches binary paths, also removes two if conditions
    # that check if the binaries are owned by root
    (substituteAll {
      src = ./binary-paths.patch;
      path = lib.makeBinPath [ networkmanager pkgs.systemd ncurses xdg-utils ];
    })
    # Patches the gi repository path of networkmanager
    # into the search path used in the library
    (substituteAll {
      src = ./gi-path-patch.patch;
      networkmanager_path = "${networkmanager}/lib/girepository-1.0";
    })
  ];

  # Fails because it attempts to connect to DBUS
  doCheck = false;

  # Disabled because importing creates a log folder
  # pythonImportsCheck = [ "protonvpn_nm_lib.api" ];

  propagatedBuildInputs = [
    proton-client
    pyxdg
    keyring
    pygobject3
    jinja2
    distro
    systemd
  ];

  meta = with lib; {
    description = "ProtonVPN NM Library";
    homepage = "https://github.com/ProtonVPN/protonvpn-nm-lib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nkje ];
    platforms = platforms.linux;
  };
}
