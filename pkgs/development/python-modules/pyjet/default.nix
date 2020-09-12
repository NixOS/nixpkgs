{ lib, buildPythonPackage, fetchFromGitHub, cython, pytest, numpy }:

buildPythonPackage rec {
  pname = "pyjet";
  version = "1.6.0";

  # tests not included in pypi tarball
  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = pname;
    rev = version;
    sha256 = "0b68jnbfk2rw9i1nnwsrbrbgkj7r0w1nw0i9f8fah1wmn78k9csv";
  };

  # fix for python37
  # https://github.com/scikit-hep/pyjet/issues/8
  nativeBuildInputs = [ cython ];
  preBuild = ''
    for f in pyjet/src/*.{pyx,pxd}; do
      cython --cplus "$f"
    done
  '';

  propagatedBuildInputs = [ numpy ];
  checkInputs = [ pytest ];
  checkPhase = ''
    mv pyjet _pyjet
    pytest tests/
  '';

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/pyjet";
    description = "The interface between FastJet and NumPy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ veprbl ];
  };
}
