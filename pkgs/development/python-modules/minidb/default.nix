{ stdenv
, buildPythonPackage
, fetchurl
, nose
, isPy3k
}:

buildPythonPackage rec {
  pname = "minidb";
  version = "2.0.2";
  disabled = !isPy3k;

  src = fetchurl {
    url = "https://github.com/thp/minidb/archive/${version}.tar.gz";
    sha256 = "17rvkpq8v7infvbgsi48vnxamhxb3f635nqn0sln7yyvh4i9k8a0";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests test
  '';

  meta = with stdenv.lib; {
    description = "A simple SQLite3-based store for Python objects";
    homepage = https://thp.io/2010/minidb/;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.tv ];
  };

}
