{ buildPythonPackage, fetchPypi, lib, zlib }:

buildPythonPackage rec {
  pname = "libfvde-python";

  version = "20220915";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tEmmSvcse7/oxObigJHcTl00WTDh5oQjX9qSbkomAzM=";
  };

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Python bindings module for libfvde";
    downloadPage = "https://github.com/libyal/libfvde/releases";
    homepage = "https://github.com/libyal/libfvde/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
