{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "pytsk3";
  name = pname;
  version = "20230125";

  meta = with lib; {
    description =
      "Python bindings for the sleuthkit (http://www.sleuthkit.org/)";
    platforms = platforms.all;
    homepage = "https://github.com/py4n6/pytsk/";
    downloadPage = "https://github.com/py4n6/pytsk/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.asl20;
  };

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RAaohJCvzGSc1Eqj6L1eiwdngiwXxQz2xomPu5YFrEI=";
  };
}
