{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "minidb";
  version = "2.0.3";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "thp";
    repo = "minidb";
    rev = version;
    sha256 = "0c6y3x957pc5sxkl34lymhkwpn4nlsfw07fcv4y9p2zdb7kjd1gc";
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
