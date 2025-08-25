{ lib
, buildPythonPackage
, cffi
, cmake
, fetchPypi
, nasm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mozjpeg-lossless-optimization";
  version = "1.1.3";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "725d98772e943fca18b0801cb94e645c477ff52e56ad0b27bddb76ddf091ca3e";
  };

  dependencies = [ cffi ];
  nativeBuildInputs = [ cmake nasm ];
  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "mozjpeg_lossless_optimization" ];

  meta = with lib; {
    changelog = "https://github.com/wanadev/${pname}/releases/tag/v${version}";
    description = "Python library to optimize JPEGs losslessly using MozJPEG";
    homepage = "https://github.com/wanadev/${pname}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nueidris ];
  };
}
