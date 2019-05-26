{ lib, fetchFromGitHub, buildPythonPackage, pytest, numpy, scipy, matplotlib, docutils
, pyopencl, opencl-headers
}:

buildPythonPackage rec {
  pname = "sasmodels";
  version = "0.99";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    rev = "v${version}";
    sha256 = "1lcvn42h29i0mg4i75xn0dbk711q9ycyhm3h95skqy8i61qmjrx6";
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
