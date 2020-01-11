{ stdenv, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05vyvsbcb99vjjs7qpbwy8j4m854w74z8di6zqsv8p9wbm38s06i";
  };

  doCheck = true;

  # stripping the tests
  postInstall = ''
    rm -rf $out/${python.sitePackages}/pony/orm/tests
  '';

  meta = with stdenv.lib; {
    description = "Pony is a Python ORM with beautiful query syntax";
    homepage = "https://ponyorm.org/";
    maintainers = with maintainers; [ d-goldin xvapx ];
    license = licenses.asl20;
  };
}
