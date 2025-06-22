{
  lib,
  buildPythonPackage,
  capnproto,
  cython,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      name = "cython-3.patch";
      url = "https://github.com/capnproto/pycapnp/pull/334.diff?full_index=1";
      hash = "sha256-we7v4RaL7c1tePWl+oYfzMHAfnvnpdMkQgVu9YLwC6Y=";
    })
  ];

  nativeBuildInputs = [
    cython
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
