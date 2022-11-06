{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, cython, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.6.1";
  pname = "gsd";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-vQutfkSilfgRHuu/THWMG6bmkT1eKlAAniQM4DP8mqI=";
  };

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    pushd gsd/test
  '';
  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "General simulation data file format";
    homepage = "https://github.com/glotzerlab/gsd";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
