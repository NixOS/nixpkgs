{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyparallel";
  version = "0.2.2";
  format = "wheel";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tVUCk69CpC17LhraEiTTw84vCbgOhUIYIOBoZVkIxhE=";
  };

  meta = with lib; {
    homepage = "https://github.com/pyserial/pyparallel";
    description = "Python parallel port access library";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ annaaurora ];
  };
}
