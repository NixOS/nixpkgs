{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "giturlparse";
  version = "0.12.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "wP/3whrMQ1SRsXeVZuA4dXogXB/9y0fk+B6lKtjDhZo=";
  };
  meta = {
    description = "Parse & rewrite git urls (supports GitHub, Bitbucket, Assembla ...)";
    homepage = "https://github.com/nephila/giturlparse";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sailord vinetos ];
  };
}
