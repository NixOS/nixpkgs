{ lib
, buildPythonPackage
, fetchFromGitHub

, setuptools
}:

buildPythonPackage rec {
  pname = "pyzstd";
  version = "0.16.0";

  format = "pyproject";

  src = fetchFromGitHub {
    repo = "pyzstd";
    owner = "Rogdham";
    rev = "${version}";
    fetchSubmodules = true;
    hash = "sha256-//SeXs65Qcrbdyj3Ilk8XYUIgpwTej0Eaxv711g+3m8=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "pyzstd" ];

  meta = with lib; {
    homepage = "https://github.com/Rogdham/pyzstd";
    description = "Python bindings to Zstandard (zstd) compression library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ByteSudoer ];
  };
}
