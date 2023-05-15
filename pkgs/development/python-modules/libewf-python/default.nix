{ buildPythonPackage, fetchPypi, lib, zlib }:

buildPythonPackage rec {
  pname = "libewf-python";

  version = "20230212";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-a7bPJVovPukGWrOV1peM314w9alB3Kk+Ow1WMlD5+LA=";
  };

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Python bindings module for libewf";
    downloadPage = "https://github.com/libyal/libewf/releases";
    homepage = "https://github.com/libyal/libewf/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };

}
