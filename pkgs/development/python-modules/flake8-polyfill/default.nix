{ lib, buildPythonPackage, fetchPypi, flake8 }:

buildPythonPackage rec {
  pname = "flake8-polyfill";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nlf1mkqw856vi6782qcglqhaacb23khk9wkcgn55npnjxshhjz4";
  };

  propagatedBuildInputs = [ flake8 ];

  meta = with lib; {
    description = "Polyfill package for Flake8 plugins";
    homepage = https://radon.readthedocs.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ lnl7 ];
  };
}
