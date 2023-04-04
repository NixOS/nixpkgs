{ buildPythonPackage, fetchPypi, lib, pyyaml }:
buildPythonPackage rec {
  pname = "dfdatetime";
  name = pname;
  version = "20230225";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k7Wbxeyca1r9jrNzK+q5K/EGQhG/Zgbqy/VAEYoWB+U=";
  };

  meta = with lib; {
    description =
      "dfDateTime, or Digital Forensics date and time, provides date and time objects to preserve accuracy and precision";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/dfdatetime";
    downloadPage = "https://github.com/log2timeline/dfdatetime/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.asl20;
  };
}
