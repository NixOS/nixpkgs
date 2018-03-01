{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pysigset";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ym44z3nwp8chfi7snmknkqnl2q9bghzv9p923r8w748i5hvyxx8";
  };

  meta = with stdenv.lib; {
    description = "Provides access to sigprocmask(2) and friends and convenience wrappers to python application developers wanting to SIG_BLOCK and SIG_UNBLOCK signals";
    homepage = https://github.com/ossobv/pysigset;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dzabraev ];
  };
}
