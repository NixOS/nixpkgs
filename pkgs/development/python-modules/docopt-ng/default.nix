{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "docopt-ng";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6mphooj8hk7uayLW/iiqIC1Z/Ib60F8W/145zE6n9uM=";
  };

  pythonImportsCheck = [ "docopt" ];
  doCheck = false; # no tests in the package

  meta = with lib; {
    description = "More-magic command line arguments parser. Now with more maintenance!";
    homepage = "https://github.com/bazaar-projects/docopt-ng";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
