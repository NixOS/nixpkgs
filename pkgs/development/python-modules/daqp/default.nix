{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  cython,
}:
buildPythonPackage {
  pname = "daqp-python";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "darnstrom";
    repo = "daqp";
    rev = "5a15a3d16731d3d50f867218c1b281567db556fd";
    hash = "sha256-in7Ci/wM7i0csJ4XVfo1lboWOyfuuU+8E+TzGmMV3x0=";
  };

  nativeBuildInputs = [unittestCheckHook];

  propagatedBuildInputs = [cython];

  postPatch = ''
    sed -i 's|../../../daqp|../..|' interfaces/daqp-python/setup.py
  '';

  buildPhase = ''
    cd interfaces/daqp-python
    python setup.py bdist_wheel
  '';

  meta = with lib; {
    description = "A dual active-set algorithm for convex quadratic programming";
    homepage = "https://github.com/darnstrom/daqp";
    license = licenses.mit;
    maintainers = with maintainers; [renesat];
  };
}
