{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "phpserialize";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19qgkb9z4zjbjxlpwh2w6pxkz2j3iymnydi69jl0jg905lqjsrxz";
  };

  # project does not have tests at the moment
  doCheck = false;

  meta = with lib; {
    description = "Port of the serialize and unserialize functions of PHP to Python";
    homepage = "https://github.com/mitsuhiko/phpserialize";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
