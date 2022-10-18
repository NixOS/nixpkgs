{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "libpyfoscam";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2E6zQT86UEOKoFnAfXfeWt352HIdOQZBGy5vR0WQO6Y=";
  };

  # tests need access to a camera
  doCheck = false;

  pythonImportsCheck = [ "libpyfoscam" ];

  meta = with lib; {
    description = "Python Library for Foscam IP Cameras";
    homepage = "https://github.com/viswa-swami/python-foscam";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
