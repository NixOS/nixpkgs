{ buildPythonPackage, fetchPypi, lib, zlib }:

buildPythonPackage rec {
  pname = "libqcow-python";

  version = "20221124";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-p0CdNcT3t2KdiTp1g00gw9tsxmuoKXInfyQBhg+64nI=";
  };

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Python bindings module for libqcow";
    downloadPage = "https://github.com/libyal/libqcow/releases";
    homepage = "https://github.com/libyal/libqcow/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
