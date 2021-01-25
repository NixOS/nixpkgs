{ lib, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f01e84e79ea7a14040225cb6c079bb266e7ba147346356c266490b18c77ce82";
  };

  doCheck = true;

  # stripping the tests
  postInstall = ''
    rm -rf $out/${python.sitePackages}/pony/orm/tests
  '';

  meta = with lib; {
    description = "Pony is a Python ORM with beautiful query syntax";
    homepage = "https://ponyorm.org/";
    maintainers = with maintainers; [ d-goldin xvapx ];
    license = licenses.asl20;
  };
}
