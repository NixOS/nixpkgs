{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "dfdatetime";

  version = "20230225";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k7Wbxeyca1r9jrNzK+q5K/EGQhG/Zgbqy/VAEYoWB+U=";
  };

  meta = with lib; {
    description = "dfDateTime, or Digital Forensics date and time, provides date and time objects to preserve accuracy and precision";
    downloadPage = "https://github.com/log2timeline/dfdatetime/releases";
    homepage = "https://github.com/log2timeline/dfdatetime";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
