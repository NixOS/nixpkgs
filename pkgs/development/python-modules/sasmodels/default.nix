{ lib, fetchFromGitHub, buildPythonPackage, pytest, numpy, scipy, matplotlib, docutils
, pyopencl, opencl-headers
}:

buildPythonPackage rec {
  pname = "sasmodels";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    rev = "v${version}";
    sha256 = "1qvh7q0fkls5r8r9mrph6igcvv8x3qsslqsc5jf1n20alcs5zjrl";
  };

  buildInputs = [ opencl-headers ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ docutils matplotlib numpy scipy pyopencl ];

  checkPhase = ''
    HOME=$(mktemp -d) py.test -c ./pytest.ini
  '';

  meta = {
    description = "Library of small angle scattering models";
    homepage = "http://sasview.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
