{
  lib,
  fetchPypi,
  buildPythonPackage,
  fetchpatch,
  libraw,
  pytest,
  mock,
}:

buildPythonPackage rec {
  pname = "rawkit";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2hwHtAmbJoN/Kk+gGXBwLo0SeiBjal9w8cFEcPLNMG8=";
  };

  patches = [
    # Python 3.7 compatibility
    (fetchpatch {
      url = "https://github.com/photoshell/rawkit/commit/663e90afa835d398aedd782c87b8cd0bff64bc9f.patch";
      hash = "sha256-vjMvAR0QGzMIwT9iyUbOyme1rkStWnmtLAvMt1IHvLE=";
    })
  ];

  buildInputs = [ libraw ];

  nativeCheckInputs = [
    pytest
    mock
  ];

  checkPhase = ''
    py.test tests
  '';

  meta = {
    description = "CTypes based LibRaw bindings for Python";
    homepage = "https://rawkit.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
