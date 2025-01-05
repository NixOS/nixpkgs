{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  fuse,
}:

buildPythonPackage rec {
  pname = "fuse-python";
  version = "1.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MhiAY2UkCM1HKuu2+S0135LIu0IAk3H4yJJ7s35r3Rs=";
  };

  buildInputs = [ fuse ];
  nativeBuildInputs = [ pkg-config ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "fuse" ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Python bindings for FUSE";
    homepage = "https://github.com/libfuse/python-fuse";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ psyanticy ];
  };
}
