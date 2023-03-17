{ lib, buildPythonPackage, pythonOlder, fetchFromGitHub, cython, pytest, importlib-resources, numpy }:

buildPythonPackage rec {
  pname = "pyjet";
  version = "1.9.0";

  # tests not included in pypi tarball
  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-0g0fCf0FIwde5Vsc/BJxjgMcs5llpD8JqOgFbMjOooc=";
  };

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [
    numpy
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    mv pyjet _pyjet
    pytest tests/
  '';

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/pyjet";
    description = "The interface between FastJet and NumPy";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ veprbl ];
  };
}
