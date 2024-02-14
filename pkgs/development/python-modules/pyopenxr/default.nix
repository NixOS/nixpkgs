{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pyopenxr";
  version = "1.0.3302";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jHz21BmtcV3Ygu2qqXkDT0TtBLWotobOtMUmA3D6v/M=";
  };

  meta = with lib; {
    homepage = "https://github.com/cmbruns/pyopenxr";
    description = "Unofficial python bindings for OpenXR access to VR and AR devices";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}

