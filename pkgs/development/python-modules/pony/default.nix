{ stdenv, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fqc45m106xfy4hhzzwb8p7s2fh5x2x7s143dib84lbszqwp77la";
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
