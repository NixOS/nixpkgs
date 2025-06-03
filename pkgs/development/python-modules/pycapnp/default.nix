{
  lib,
  buildPythonPackage,
  capnproto,
  cython_0,
  fetchFromGitHub,
  isPy27,
  isPyPy,
  pkgconfig,
}:

buildPythonPackage rec {
  pname = "pycapnp";
  version = "2.0.0";
  format = "setuptools";
  disabled = isPyPy || isPy27;

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "pycapnp";
    tag = "v${version}";
    sha256 = "sha256-SVeBRJMMR1Z8+S+QoiUKGRFGUPS/MlmWLi1qRcGcPoE=";
  };

  nativeBuildInputs = [
    cython_0
    pkgconfig
  ];

  buildInputs = [ capnproto ];

  # Tests depend on schema_capnp which fails to generate
  doCheck = false;

  pythonImportsCheck = [ "capnp" ];

  meta = with lib; {
    homepage = "https://capnproto.github.io/pycapnp/";
    maintainers = [ ];
    license = licenses.bsd2;
  };
}
