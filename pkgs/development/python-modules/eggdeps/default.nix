{
  lib,
  buildPythonPackage,
  fetchPypi,
  zope-interface,
  zope-testing,
}:

buildPythonPackage rec {
  pname = "tl-eggdeps";
  version = "1.0";

  src = fetchPypi {
    inherit version;
    pname = "tl.eggdeps";
    hash = "sha256-oJTteWGj3Tj8qqac96WGcAOKzf8YY2AWbZ49lkt6cyM=";
  };

  propagatedBuildInputs = [
    zope-interface
    zope-testing
  ];

  # tests fail, see https://hydra.nixos.org/build/4316603/log/raw
  doCheck = false;

  meta = with lib; {
    description = "Tool which computes a dependency graph between active Python eggs";
    mainProgram = "eggdeps";
    homepage = "http://thomas-lotze.de/en/software/eggdeps/";
    license = licenses.zpl20;
  };
}
