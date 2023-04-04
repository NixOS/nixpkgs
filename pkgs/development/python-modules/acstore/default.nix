{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "acstore";
  name = pname;
  version = "20230226";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MDeWOU1cv6dW8LL2UmdUbSwm0vg4YfxvpTDTb15+/+s=";
  };

  meta = with lib; {
    description =
      "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/acstore";
    downloadPage = "https://github.com/log2timeline/acstore/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ jayrovacsek ];
  };
}
