{ buildPythonPackage, fetchPypi, lib, pyyaml }:
buildPythonPackage rec {
  pname = "artifacts";
  name = pname;
  version = "20221219";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rCmmzA9OmUiJPVrOJu2N61zj6Z4MysJP6fOTKRibCm0=";
  };

  meta = with lib; {
    description =
      "A free, community-sourced, machine-readable knowledge base of forensic artifacts that the world can use both as an information source and within other tools";
    homepage = "https://github.com/ForensicArtifacts/artifacts";
    downloadPage = "https://github.com/ForensicArtifacts/artifacts/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ jayrovacsek ];
  };

  propagatedBuildInputs = [ pyyaml ];
}
