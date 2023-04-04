{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libolecf-python";
  name = pname;
  version = "20221024";

  meta = with lib; {
    description = "Python bindings module for libolecf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libolecf/";
    downloadPage = "https://github.com/libyal/libolecf/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Wtj5f5NRxzc4x49Gh6gqIJ4UZvcEPuGp6NiAqry23qQ=";
  };
}
