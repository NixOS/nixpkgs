{ lib, buildPythonPackage, fetchPypi, pytestCheckHook
, atpublic, psutil, pytest-cov, sybil
}:

buildPythonPackage rec {
  pname = "flufl.lock";
  version = "5.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bnapkg99r6mixn3kh314bqcfk8q54y0cvhjpj87j7dhjpsakfpz";
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
