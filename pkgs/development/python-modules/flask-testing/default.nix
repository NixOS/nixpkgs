{ stdenv, fetchPypi, buildPythonPackage, isPy3k, flask, blinker, twill }:

buildPythonPackage rec {
  pname = "Flask-Testing";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rkkqgmrzmhpv6y1xysqh0ij03xniic8h631yvghksqwxd9vyjfq";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "twill==0.9.1" "twill"
  '';

  propagatedBuildInputs = [ flask ];

  checkInputs = [ blinker ] ++ stdenv.lib.optionals (!isPy3k) [ twill ];

  # twill integration is outdated in Python 2, hence it the tests fails.
  # Some of the tests use localhost networking on darwin.
  doCheck = isPy3k && !stdenv.isDarwin;

  pythonImportsCheck = [ "flask_testing" ];

  meta = with stdenv.lib; {
    description = "Flask unittest integration.";
    homepage = "https://pythonhosted.org/Flask-Testing/";
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
  };
}
