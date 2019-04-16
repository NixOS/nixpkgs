{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Chameleon";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "850f74f756bcb99423dd2658b99f448b09f09ccc2c60c0a2d6dec52294d7f9ed";
  };

  meta = with stdenv.lib; {
    homepage = https://chameleon.readthedocs.io/;
    description = "Fast HTML/XML Template Compiler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
