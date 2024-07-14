{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pysigset";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E++YsFhIn/VytmZ8OJcKVEaZiVwIRMs6wklOOlmsUeY=";
  };

  meta = with lib; {
    description = "Provides access to sigprocmask(2) and friends and convenience wrappers to python application developers wanting to SIG_BLOCK and SIG_UNBLOCK signals";
    homepage = "https://github.com/ossobv/pysigset";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dzabraev ];
  };
}
