{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "libpyfoscam";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c274cafd2c6493ab397fe9f0f8aae0b2c35c7c661fe76dde3bd2f1cd56b8fc32";
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
