{ stdenv
, lib
, fetchurl
, buildPythonPackage
, pybind11
, dijitso
, fiat
, numpy
, six
, sympy
, ufl
, setuptools
, pytestCheckHook
, dolfin
}:

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

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$PWD
  '';

  disabledTests = [ "test_evalute" ];

  pytestFlagsArray = [ "test/" ];

  pythonImportsCheck = [ "ffc" ];

  meta = with lib; {
    description = "A compiler for finite element variational forms";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
