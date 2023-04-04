{ buildPythonPackage, fetchPypi, lib, pyyaml, mock }:
buildPythonPackage rec {
  pname = "dtfabric";
  name = pname;
  version = "20221218";

  meta = with lib; {
    description =
      "dtFabric, or data type fabric, is a project to manage data types and structures, as used in the libyal projects";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/dtfabric/";
    downloadPage = "https://github.com/libyal/dtfabric/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E4HOdIBj0Mcy/PNDStwXmsjwW3WpZJYmFDDWvRaTPlU=";
  };

  nativeCheckInputs = [ mock ];

  propagatedBuildInputs = [ pyyaml ];
}
