{ stdenv, python, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02njpqwfvzxj9icabil8ycmfx8avzih3g1kcdif290qgsy57a28r";
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
