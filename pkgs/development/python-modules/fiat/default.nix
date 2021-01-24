{ stdenv
, lib
, fetchurl
, python3Packages
, dolfin
}:

python3Packages.buildPythonPackage rec {
  pname = "fiat";
  inherit (dolfin) version;

  src = fetchurl {
    url = "https://bitbucket.org/fenics-project/fiat/downloads/fiat-${version}.tar.gz";
    sha256 = "1sbi0fbr7w9g9ajr565g3njxrc3qydqjy3334vmz5xg0rd3106il";
  };

  propagatedBuildInputs = with python3Packages; [ numpy six sympy ];

  checkInputs = with python3Packages; [ pytest ];

  preCheck = ''
    # Workaround pytest 4.6.3 issue.
    # See: https://bitbucket.org/fenics-project/fiat/pull-requests/59
    rm test/unit/test_quadrature.py
    rm test/unit/test_reference_element.py
    rm test/unit/test_fiat.py
  '';

  checkPhase = ''
    runHook preCheck
    py.test test/unit/
    runHook postCheck
  '';

  meta = with lib; {
    description = "Automatic generation of arbitrary order instances of the Lagrange elements on lines, triangles, and tetrahedra";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
