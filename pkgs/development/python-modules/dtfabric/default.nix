{ buildPythonPackage, fetchPypi, lib, pyyaml, mock }:

buildPythonPackage rec {
  pname = "dtfabric";

  version = "20221218";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E4HOdIBj0Mcy/PNDStwXmsjwW3WpZJYmFDDWvRaTPlU=";
  };

  nativeCheckInputs = [ mock ];

  propagatedBuildInputs = [ pyyaml ];

  meta = with lib; {
    description = "dtFabric, or data type fabric, is a project to manage data types and structures, as used in the libyal projects";
    downloadPage = "https://github.com/libyal/dtfabric/releases";
    homepage = "https://github.com/libyal/dtfabric/";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
