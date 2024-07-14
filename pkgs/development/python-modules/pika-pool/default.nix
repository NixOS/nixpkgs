{
  lib,
  buildPythonPackage,
  fetchPypi,
  pika,
}:

buildPythonPackage rec {
  pname = "pika-pool";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-85hYiMwniM29KTpoqLVwKpyVXbb3uLVRrqyR5/Mto5c=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "pika >=0.9,<0.11" "pika"
  '';

  # Tests require database connections
  doCheck = false;

  propagatedBuildInputs = [ pika ];
  meta = with lib; {
    homepage = "https://github.com/bninja/pika-pool";
    license = licenses.bsdOriginal;
    description = "Pools for pikas";
  };
}
