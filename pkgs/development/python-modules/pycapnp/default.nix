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

  nativeBuildInputs = [ cython pkgconfig ];

  buildInputs = [ capnproto ];

  # Tests depend on schema_capnp which fails to generate
  doCheck = false;

  pythonImportsCheck = [ "capnp" ];

  meta = with lib; {
    homepage = "https://capnproto.github.io/pycapnp/";
    maintainers = with maintainers; [ cstrahan lukeadams ];
    license = licenses.bsd2;
  };
}
