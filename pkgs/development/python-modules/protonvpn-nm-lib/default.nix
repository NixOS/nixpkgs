{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, distro
, jinja2
, keyring
, proton-client
, pygobject3
, pyxdg
, systemd
}:

buildPythonPackage rec {
  pname = "protonvpn-nm-lib";
  version = "3.8.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = pname;
    rev = version;
    sha256 = "sha256-fAaP9c66LcbZgezadGPUt400YRnrnFoBvpzlc1zxuc4=";
  };

  propagatedBuildInputs = [
    distro
    jinja2
    keyring
    proton-client
    pygobject3
    pyxdg
    systemd
  ];

  # Project has a dummy test.
  doCheck = false;

  pythonImportsCheck = [ "protonvpn_nm_lib" ];

  meta = with lib; {
    description = "ProtonVPN NetworkManager Library intended for every ProtonVPN service user";
    homepage = "https://github.com/ProtonVPN/protonvpn-nm-lib";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
