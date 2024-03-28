{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "acstore";

  version = "20230226";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MDeWOU1cv6dW8LL2UmdUbSwm0vg4YfxvpTDTb15+/+s=";
  };

  meta = with lib; {
    description = "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files";
    downloadPage = "https://github.com/log2timeline/acstore/releases";
    homepage = "https://github.com/log2timeline/acstore";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
