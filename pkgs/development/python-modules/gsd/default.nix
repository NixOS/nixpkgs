{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, cython, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.5.1";
  pname = "gsd";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = pname;
    rev = "v${version}";
    sha256 = "00cy4lw7xnl2skfx7fg7cs1c8lrbaxvkym9j6zfi1dbvsdd0r103";
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
