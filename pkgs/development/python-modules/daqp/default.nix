{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, unittestCheckHook
, cython
, setuptools
, wheel
, numpy
}:
buildPythonPackage {
  pname = "daqp";
  version = "0.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "darnstrom";
    repo = "daqp";
    rev = "5a15a3d16731d3d50f867218c1b281567db556fd";
    hash = "sha256-in7Ci/wM7i0csJ4XVfo1lboWOyfuuU+8E+TzGmMV3x0=";
  };

  sourceRoot = "source/interfaces/daqp-python";

  postPatch = ''
    sed -i 's|../../../daqp|../..|' setup.py
    sed -i 's|if src_path and os.path.exists(src_path):|if False:|' setup.py
  '';

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "test" "-p" "'*.py'" "-v" ];

  nativeBuildInputs = [
    cython
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "daqp" ];

  meta = with lib; {
    description = "A dual active-set algorithm for convex quadratic programming";
    homepage = "https://github.com/darnstrom/daqp";
    license = licenses.mit;
    maintainers = with maintainers; [ renesat ];
  };
}
