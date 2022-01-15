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
  version = "1.1.0";
  disabled = isPyPy || isPy27;

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xi6df93ggkpmwckwbi356v7m32zv5qry8s45hvsps66dz438kmi";
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
