{ lib, buildPythonPackage, fetchPypi, pytestCheckHook
, atpublic, psutil, pytest-cov, sybil
}:

buildPythonPackage rec {
  pname = "flufl.lock";
  version = "6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc748ee609ec864b4838ef649dbd1170fa79deb0c213c2fd51151bee6a7fc242";
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
