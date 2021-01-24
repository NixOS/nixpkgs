{ stdenv
, lib
, fetchurl
, python3Packages
, dolfin
}:

with python3Packages;

buildPythonPackage rec {
  pname = "ffc";
  inherit (dolfin) version;

  src = fetchurl {
    url = "https://bitbucket.org/fenics-project/ffc/downloads/ffc-${version}.tar.gz";
    sha256 = "1zdg6pziss4va74pd7jjl8sc3ya2gmhpypccmyd8p7c66ji23y2g";
  };

  nativeBuildInputs = [
    pybind11
  ];

  propagatedBuildInputs = [
    dijitso
    fiat
    numpy
    six
    sympy
    ufl
    setuptools
  ];

  checkInputs = [ pytest ];

  preCheck = ''
    export HOME=$PWD
    rm test/unit/ufc/finite_element/test_evaluate.py
  '';

  checkPhase = ''
    runHook preCheck
    py.test test/unit/
    runHook postCheck
  '';

  pythonImportsCheck = [ "ffc" ];

  meta = with lib; {
    description = "A compiler for finite element variational forms";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
