{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, ipython
, numpy
, pyserial
, pyusb
, hostPlatform
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rfcat";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "atlas0fd00m";
    repo = "rfcat";
    rev = "v${version}";
    sha256 = "1mmr7g7ma70sk6vl851430nqnd7zxsk7yb0xngwrdx9z7fbz2ck0";
  };

  propagatedBuildInputs = [
    future
    ipython
    numpy
    pyserial
    pyusb
  ];

  postInstall = lib.optionalString hostPlatform.isLinux ''
    mkdir -p $out/etc/udev/rules.d
    cp etc/udev/rules.d/20-rfcat.rules $out/etc/udev/rules.d
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rflib" ];

  meta = with lib; {
    description = "Swiss Army knife of sub-GHz ISM band radio";
    homepage = "https://github.com/atlas0fd00m/rfcat";
    license = licenses.bsd3;
    maintainers = with maintainers; [ trepetti ];
    changelog = "https://github.com/atlas0fd00m/rfcat/releases/tag/v${version}";
  };
}
