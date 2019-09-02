{ lib, fetchFromGitHub, buildPythonPackage, pytest, numpy, scipy, matplotlib, docutils
, pyopencl, opencl-headers
}:

buildPythonPackage rec {
  pname = "sasmodels";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    rev = "v${version}";
    sha256 = "082wnk10axincc4a62zxyr33l7v80yf7iz630y3421b50fwwyd8j";
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
