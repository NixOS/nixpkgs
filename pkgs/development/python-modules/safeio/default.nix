{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "safeio";
  version = "1.2";

  src = fetchPypi {
    pname = "safeIO";
    inherit version;
    sha256 = "d480a6dab01a390ebc24c12d6b774ad00cef3db5348ad07d8bd11d272a808cd3";
  };

  pythonImportsCheck = [ "safeIO" ];

  meta = with lib; {
    description = "Safely make I/O operations to files in Python even from multiple threads";
    homepage = "https://github.com/Animenosekai/safeIO";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
