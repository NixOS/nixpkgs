{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "minidb";
  version = "2.0.4";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "thp";
    repo = "minidb";
    rev = version;
    sha256 = "0i607rkfx0rkyllcx4vf3w2z0wxzs1gqigfw87q90pjrbbh2q4sb";
  };

  # module imports are incompatible with python2
  doCheck = isPy3k;
  checkInputs = [ nose pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A simple SQLite3-based store for Python objects";
    homepage = "https://thp.io/2010/minidb/";
    license = licenses.isc;
    maintainers = [ maintainers.tv ];
  };

}
