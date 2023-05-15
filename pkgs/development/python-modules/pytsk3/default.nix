{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "pytsk3";

  version = "20230125";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RAaohJCvzGSc1Eqj6L1eiwdngiwXxQz2xomPu5YFrEI=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Python bindings for the sleuthkit (http://www.sleuthkit.org/)";
    downloadPage = "https://github.com/py4n6/pytsk/releases";
    homepage = "https://github.com/py4n6/pytsk/";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
