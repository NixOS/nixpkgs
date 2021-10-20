{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pysmt";
  version = "0.9.1.dev132";
  format = "wheel"; # dev versions are only distributed as wheels

  src = fetchPypi {
    pname = "PySMT";
    inherit format version;
    sha256 = "01iqs7yzms3alf1rdv0gnsnmfp7g8plkjcdqbari258zp4llf6x7";
  };

  # No tests present, only GitHub release which is 0.9.0
  doCheck = false;

  pythonImportsCheck = [ "pysmt" ];

  meta = with lib; {
    description = "Python library for SMT formulae manipulation and solving";
    homepage = "https://github.com/pysmt/pysmt";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
