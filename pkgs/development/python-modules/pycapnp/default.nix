{ lib
, buildPythonPackage
, capnproto
, cython
, fetchFromGitHub
, isPy27
, isPyPy
, pkgconfig
}:

buildPythonPackage rec {
  pname = "pycapnp";
  version = "1.0.0";
  disabled = isPyPy || isPy27;

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n6dq2fbagi3wvrpkyb7wx4y15nkm2grln4y75hrqgmnli8ggi9v";
  };

  buildInputs = [ capnproto cython pkgconfig ];

  # Tests disabled due to dependency on jinja and various other libraries.
  doCheck = false;

  pythonImportsCheck = [ "capnp" ];

  meta = with lib; {
    maintainers = with maintainers; [ cstrahan lukeadams ];
    license = licenses.bsd2;
    homepage = "https://capnproto.github.io/pycapnp/";
  };
}
