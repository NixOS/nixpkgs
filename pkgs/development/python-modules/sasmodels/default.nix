{ lib, fetchFromGitHub, buildPythonPackage, pytest, numpy, scipy, matplotlib, docutils
, pyopencl, opencl-headers
}:

buildPythonPackage rec {
  pname = "sasmodels-unstable";
  version = "2018-04-27";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    rev = "33969b656596e8b6cc8ce934cd1f8062f7b11cf2";
    sha256 = "00rvhafg08qvx0k9mzn1ppdkc9i5yfn2gr3hidrf416srf8zgb85";
  };

  buildInputs = [ opencl-headers ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ docutils matplotlib numpy scipy pyopencl ];

  checkPhase = ''
    HOME=$(mktemp -d) py.test -c ./pytest.ini
  '';

  meta = {
    description = "Library of small angle scattering models";
    homepage = http://sasview.org;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
