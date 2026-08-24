{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "imagesize";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-srpqTepIen681TJI00dqykSdMNsSot3l4MXKliT9d+U=";
  };

  meta = {
    description = "Getting image size from png/jpeg/jpeg2000/gif file";
    homepage = "https://github.com/shibukawa/imagesize_py";
    license = lib.licenses.mit;
  };
}
