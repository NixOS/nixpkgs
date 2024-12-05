{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  libjack2,
  nix-update-script,
}:
let
  version = "0.5.5";
in
buildPythonPackage {
  pname = "jack-client";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spatialaudio";
    repo = "jackclient-python";
    tag = version;
    hash = "sha256-SqDHFUlAtGbT/UJALykPvdP7+5KUlZkMpwYDjq+rU98=";
  };

  build-system = [ setuptools ];
  dependencies = [ cffi ];

  # Imports check dlopens libjack :V
  postFixup = ''
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ libjack2 ]}
  '';

  pythonImportsCheck = [ "jack" ];

  # No unit tests; doctests require actual running JACK environment
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JACK Audio Connection Kit (JACK) Client for Python";
    homepage = "https://jackclient-python.readthedocs.io/";
    changelog = "https://jackclient-python.readthedocs.io/en/${version}/version-history.html";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
