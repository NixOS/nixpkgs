{ buildPythonPackage, fetchPypi, lib, zlib }:
buildPythonPackage rec {
  pname = "libfvde-python";
  name = pname;
  version = "20220915";

  meta = with lib; {
    description = "Python bindings module for libfvde";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfvde/";
    downloadPage = "https://github.com/libyal/libfvde/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tEmmSvcse7/oxObigJHcTl00WTDh5oQjX9qSbkomAzM=";
  };
}
