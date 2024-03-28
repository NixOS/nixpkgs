{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libolecf-python";

  version = "20221024";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Wtj5f5NRxzc4x49Gh6gqIJ4UZvcEPuGp6NiAqry23qQ=";
  };

  meta = with lib; {
    description = "Python bindings module for libolecf";
    downloadPage = "https://github.com/libyal/libolecf/releases";
    homepage = "https://github.com/libyal/libolecf/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
