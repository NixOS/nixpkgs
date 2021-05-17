{ stdenv
, lib
, fetchFromBitbucket
, buildPythonPackage
, numpy
, sympy
, six
, pytestCheckHook
, dolfin
}:

buildPythonPackage rec {
  pname = "fiat";
  inherit (dolfin) version;

  src = fetchFromBitbucket {
    owner = "fenics-project";
    repo = "fiat";
    rev = version;
    sha256 = "01fy7fyi570gz4l5jwgx6091xfrnbkgf27sxdi5s1z4kkasdv492";
  };

  propagatedBuildInputs = [ numpy six sympy ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    # Workaround pytest 4.6.3 issue.
    # See: https://bitbucket.org/fenics-project/fiat/pull-requests/59
    "test_quadrature"
    "test_reference_element"
    "tes_fiat"
  ];

  pytestFlagsArray = [ "test/unit/" ];

  meta = with lib; {
    description = "Automatic generation of arbitrary order instances of the Lagrange elements on lines, triangles, and tetrahedra";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
