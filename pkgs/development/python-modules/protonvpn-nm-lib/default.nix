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
  version = "3.7.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = pname;
    rev = version;
    sha256 = "1mmma8ril4vi22mpxnw38vj22xsczrmmn89as0in9x70yakp97a5";
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
