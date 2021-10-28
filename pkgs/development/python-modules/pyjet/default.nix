{ lib, buildPythonPackage, fetchFromGitHub, cython, pytest, numpy }:

buildPythonPackage rec {
  pname = "pyjet";
  version = "1.8.2";

  # tests not included in pypi tarball
  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = pname;
    rev = version;
    sha256 = "sha256-0EI/dbanVDvILawnnK/Ce/5n/cD4Fv7VQEZfF9yPQio=";
  };

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytest ];
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
