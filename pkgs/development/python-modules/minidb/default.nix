{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "minidb";
  version = "2.0.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "thp";
    repo = "minidb";
    rev = version;
    sha256 = "14y5vf8vhgviczhzy9h3xv99fjvrg975nz4w1fj5c1jv37da1lq3";
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
