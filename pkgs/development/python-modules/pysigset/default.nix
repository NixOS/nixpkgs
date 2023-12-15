{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pysigset";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13ef98b058489ff572b6667c38970a544699895c0844cb3ac2494e3a59ac51e6";
  };

  meta = with lib; {
    description = "Provides access to sigprocmask(2) and friends and convenience wrappers to python application developers wanting to SIG_BLOCK and SIG_UNBLOCK signals";
    homepage = "https://github.com/ossobv/pysigset";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dzabraev ];
  };
}
