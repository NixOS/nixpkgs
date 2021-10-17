{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, cython, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.5.0";
  pname = "gsd";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zw3ihbzkldwijz9phwivnzwylj30a2a4lknfbwm6vkx78rdrb1a";
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
