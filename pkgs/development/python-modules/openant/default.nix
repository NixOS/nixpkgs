{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pyusb
}:

buildPythonPackage rec {
  pname = "openant-unstable";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tigge";
    repo = "openant";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ook9dwcyWvpaGylVDjBxQ2bnXRUBPYQHo6Wub+ISpwE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  postInstall = ''
    install -dm755 "$out/etc/udev/rules.d"
    install -m644 resources/42-ant-usb-sticks.rules "$out/etc/udev/rules.d/99-ant-usb-sticks.rules"
  '';

  propagatedBuildInputs = [ pyusb ];

  meta = with lib; {
    homepage = "https://github.com/Tigge/openant";
    description = "ANT and ANT-FS Python Library";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
