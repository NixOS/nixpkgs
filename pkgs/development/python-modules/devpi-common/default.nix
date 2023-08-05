{ lib, buildPythonPackage, fetchPypi
, requests
, py
, pytestCheckHook
, lazy
}:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.7.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kHiYknmteenBgce63EpzhGBEUYcQHrDLreZ1k01eRkQ=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--flake8" ""
  '';

  propagatedBuildInputs = [
    requests
    py
    lazy
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/devpi/devpi";
    description = "Utilities jointly used by devpi-server and devpi-client";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
    # It fails to build because it depends on packaging <22 while we
    # use packaging >22.
    # See the following issues for details:
    # - https://github.com/NixOS/nixpkgs/issues/231346
    # - https://github.com/devpi/devpi/issues/939
    broken = true;
  };
}
