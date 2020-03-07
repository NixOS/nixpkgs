{ lib, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "fastscript";
  version = "0.1.4";
  disabled = !isPy3k;

  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "18scdyr4s7nby2vdnsmw7izyzbqw56sqrx57d0arhqvrh8xx35f4";

    python = "py3";
  };

  meta = with lib; {
    description = "A fast way to turn your python function into a script ";
    homepage = "https://fastscript.fast.ai";
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
