{
  lib,
  fetchPypi,
  buildPythonPackage,
  fetchpatch,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "elevate";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53ad19fa1de301fb1de3f8768fb3a5894215716fd96a475690c4d0ff3b1de209";
  };

  patches = [
    (fetchpatch {
      # This is for not calling shell wrappers through Python, which fails.
      url = "https://github.com/rkitover/elevate/commit/148b2bf698203ea39c9fe5d635ecd03cd94051af.patch";
      sha256 = "1ky3z1jxl1g28wbwbx8qq8jgx8sa8pr8s3fdcpdhdx1blw28cv61";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "elevate" ];

  meta = with lib; {
    description = "Python module for re-launching the current process as super-user";
    homepage = "https://github.com/barneygale/elevate";
    license = licenses.mit;
    maintainers = with maintainers; [ rkitover ];
  };
}
