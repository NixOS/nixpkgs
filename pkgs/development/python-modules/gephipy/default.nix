{
  lib,
  pkgs,
  buildPythonPackage,

  fetchPypi,

  jdk21_headless,
  poetry-core,

  jpype1,
  networkx,
}:
let
  gephi-toolkit = pkgs.fetchMavenArtifact {
    groupId = "org.gephi";
    artifactId = "gephi-toolkit";
    version = "0.10.1";
    classifier = "all";
    hash = "sha256-Pk9f1sfR11weC/vq5CzFih0irnxdeTpJjmxYQvIr8Cc=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "gephipy";
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = finalAttrs.pname;
    version = finalAttrs.version;

    hash = "sha256-r3hHcDEX17SNr9l4m9oEVXAky03wSGAbEznV6rPEMf0=";
  };

  build-system = [ poetry-core ];

  buildInputs = [
    jdk21_headless
  ];

  dependencies = [
    networkx
    jpype1
  ];

  pythonImportsCheck = [ "gephipy" ];

  # during first use, they download the gephi .jar. applying a patch that links to the nix store
  postPatch = ''
    substituteInPlace gephipy/gephipy.py --replace-fail "jvm.start()" 'jvm.start(gephi_jar_path="${gephi-toolkit.passthru.jar}")'
  '';

  meta = {
    description = "A wrapper of Gephi toolkit for Python";
    homepage = "https://github.com/gephi/gephipy/";
    maintainers = with lib.maintainers; [ demic-dev ];
    license = lib.licenses.mit;
  };
})
