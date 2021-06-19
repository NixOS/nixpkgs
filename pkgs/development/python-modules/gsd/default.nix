{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, cython, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.4.2";
  pname = "gsd";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yv84girmqm155yjhhkiy1gdflf62110m2kgjiv4vcsjpy2i6has";
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
