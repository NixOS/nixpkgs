{ lib, buildPythonPackage, fetchPypi, pytestCheckHook
, atpublic, psutil, pytest-cov, sybil
}:

buildPythonPackage rec {
  pname = "flufl.lock";
  version = "5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ylahys50vaj7iw6dhlx3gg7vs8cms9sbyvscd06clnk6lqk78ad";
  };

  propagatedBuildInputs = [ atpublic psutil ];
  checkInputs = [ pytestCheckHook pytest-cov sybil ];

  # disable code coverage checks for all OS. Upstream does not enforce these
  # checks on Darwin, and code coverage cannot be improved downstream nor is it
  # relevant to the user.
  pytestFlagsArray = [ "--no-cov" ];

  meta = with lib; {
    homepage = "https://flufllock.readthedocs.io/";
    description = "NFS-safe file locking with timeouts for POSIX and Windows";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
