{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "commandlines";
  name = pname;
  version = "0.4.1";

  meta = with lib; {
    description =
      "Commandlines is a Python library for command line application development that supports command line argument parsing";
    platforms = platforms.all;
    homepage = "https://github.com/chrissimpkins/commandlines";
    downloadPage = "https://github.com/chrissimpkins/commandlines/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ jayrovacsek ];
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hrZQt4RwrJWWbXsanSFcFlkbzLNLKK4ruQJsO0Fm/WQ=";
  };
}
