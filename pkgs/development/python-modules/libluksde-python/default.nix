{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libluksde-python";

  version = "20221103";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gPpmClunyK3QE889K30TK/gX2uGbVHQ3sjSWq67B5fY=";
  };

  meta = with lib; {
    description = "Python bindings module for libluksde";
    downloadPage = "https://github.com/libyal/libluksde/releases";
    homepage = "https://github.com/libyal/libluksde/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
