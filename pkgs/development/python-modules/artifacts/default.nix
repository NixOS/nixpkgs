{ buildPythonPackage, fetchPypi, lib, pyyaml }:

buildPythonPackage rec {
  pname = "artifacts";

  version = "20221219";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rCmmzA9OmUiJPVrOJu2N61zj6Z4MysJP6fOTKRibCm0=";
  };

  propagatedBuildInputs = [ pyyaml ];

  meta = with lib; {
    description = "A free, community-sourced, machine-readable knowledge base of forensic artifacts that the world can use both as an information source and within other tools";
    downloadPage = "https://github.com/ForensicArtifacts/artifacts/releases";
    homepage = "https://github.com/ForensicArtifacts/artifacts";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
