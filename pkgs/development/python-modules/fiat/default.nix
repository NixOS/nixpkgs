{ stdenv
, lib
, fetchurl
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

  src = fetchurl {
    url = "https://bitbucket.org/fenics-project/fiat/downloads/fiat-${version}.tar.gz";
    sha256 = "1sbi0fbr7w9g9ajr565g3njxrc3qydqjy3334vmz5xg0rd3106il";
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
