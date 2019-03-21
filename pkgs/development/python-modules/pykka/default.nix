{ stdenv
, buildPythonPackage
, fetchgit
}:

buildPythonPackage rec {
  pname = "pykka";
  version = "1.2.0";

  src = fetchgit {
    url = "https://github.com/jodal/pykka.git";
    rev = "refs/tags/v${version}";
    sha256 = "0qlfw1054ap0cha1m6dbnq51kjxqxaf338g7jwnwy33b3gr8x0hg";
  };

  # There are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://www.pykka.org;
    description = "A Python implementation of the actor model";
    license = licenses.asl20;
    maintainers = with maintainers; [ rickynils ];
  };

}
