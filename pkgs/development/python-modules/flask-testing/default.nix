{ lib, stdenv, fetchPypi, buildPythonPackage, isPy3k, flask, blinker, twill }:

buildPythonPackage rec {
  pname = "Flask-Testing";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a734d7b68e63a9410b413cd7b1f96456f9a858bd09a6222d465650cc782eb01";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "twill==0.9.1" "twill"
  '';

  propagatedBuildInputs = [ flask ];

  checkInputs = [ blinker ] ++ lib.optionals (!isPy3k) [ twill ];

  # twill integration is outdated in Python 2, hence it the tests fails.
  # Some of the tests use localhost networking on darwin.
  doCheck = isPy3k && !stdenv.isDarwin;

  pythonImportsCheck = [ "flask_testing" ];

  meta = with lib; {
    description = "Flask unittest integration.";
    homepage = "https://pythonhosted.org/Flask-Testing/";
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
  };
}
