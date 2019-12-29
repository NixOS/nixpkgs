{ lib
, buildPythonPackage
, fetchFromGitHub
, capnproto
, cython
, isPyPy
, isPy27
, pytest
}:

buildPythonPackage rec {
  pname = "pycapnp";
  version = "1.0.0b1";
  disabled = isPyPy || isPy27;

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m0ax6rfkpravc0sph1rmivvfps9kcqsc8va5bvabdwds6in7rsn";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    capnproto
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pushd dist
    pytest ../test --ignore ../test/test_examples.py
    popd
  '';

  meta = with lib; {
    maintainers = with maintainers; [ cstrahan ];
    license = licenses.bsd2;
    homepage = "http://jparyani.github.io/pycapnp/index.html";
    description = "Cap'n Proto serialization/RPC system - Python bindings";
  };

}
