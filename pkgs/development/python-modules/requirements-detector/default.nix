{ buildPythonPackage
, fetchFromGitHub
, isPy27
, lib

# pythonPackages
, pytest
}:

buildPythonPackage rec {
  pname = "requirements-detector";
  version = "0.6";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "yuvadm";
    repo = pname;
    rev = version;
    sha256 = "15s0n1lhkz0zwi33waqkkjipal3f7s45rxsj1bw89xpr4dj87qx5";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "Python tool to find and list requirements of a Python project";
    homepage = "https://github.com/landscapeio/requirements-detector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
