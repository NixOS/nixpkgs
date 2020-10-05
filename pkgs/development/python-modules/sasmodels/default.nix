{ lib, fetchFromGitHub, buildPythonPackage, pytest, numpy, scipy, matplotlib, docutils
, pyopencl, opencl-headers
}:

buildPythonPackage rec {
  pname = "sasmodels";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    rev = "v${version}";
    sha256 = "0h2k81dm92sm0z086qy3ipw6y6cfgpb7ppl7lhjmx6816s3k50sa";
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
