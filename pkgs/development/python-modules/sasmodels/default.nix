{ lib
, fetchFromGitHub
, buildPythonPackage
, pytest
, numpy
, scipy
, matplotlib
, docutils
, pyopencl
, opencl-headers
}:

buildPythonPackage rec {
  pname = "sasmodels";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    rev = "v${version}";
    sha256 = "19h30kcgpvg1qirzjm0vhgvp1yn60ivlglc8a8n2b4d9fp0acfyd";
  };

  buildInputs = [ opencl-headers ];
  # Note: the 1.0.5 release should be compatible with pytest6, so this can
  # be set back to 'pytest' at that point
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
