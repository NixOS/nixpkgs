{ buildPythonPackage
, lib
, absl-py
, deepdiff
, dm_env
, fetchFromGitHub
, future
, mock
, mpyq
, numpy
, portpicker
, protobuf
, pygame
, pythonRelaxDepsHook
, requests
, s2clientprotocol
, s2protocol
, sc2-headless
, sk-video
, websocket-client
}:

buildPythonPackage rec {
  pname = "PySC2";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "pysc2";
    rev = "v${version}";
    hash = "sha256-70Uqs30Dyq1u+e1CTR8mO/rzZangBvgY0ah2l7VJLhQ=";
  };

  patches = [
    ./parameterize-runconfig-sc2path.patch
    ./remove_enum32.patch
  ];

  postPatch = ''
    substituteInPlace "./pysc2/run_configs/platforms.py" \
      --subst-var-by 'sc2path' '${sc2-headless}'
  '';

  propagatedBuildInputs = [
    absl-py
    deepdiff
    dm_env # https://github.com/deepmind/dm_env
    mock
    mpyq
    numpy
    portpicker
    protobuf
    pygame
    requests
    s2clientprotocol
    s2protocol # https://github.com/Blizzard/s2protocol
    sk-video # https://www.scikit-video.org/stable/
    websocket-client
  ];

  meta = {
    description = "Starcraft II environment and library for training agents.";
    homepage = "https://github.com/deepmind/pysc2";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
