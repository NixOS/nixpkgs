{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "phpserialize";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19qgkb9z4zjbjxlpwh2w6pxkz2j3iymnydi69jl0jg905lqjsrxz";
  };

  # project does not have tests at the moment
  doCheck = false;

  meta = {
    description = "A port of the serialize and unserialize functions of PHP to Python";
    homepage = http://github.com/mitsuhiko/phpserialize;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
