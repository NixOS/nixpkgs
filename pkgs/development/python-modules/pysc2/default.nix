{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  absl-py,
  enum34,
  future,
  mock,
  mpyq,
  numpy,
  portpicker,
  protobuf,
  pygame,
  s2clientprotocol,
  six,
  websocket-client,
  sc2-headless,
}:

buildPythonPackage {
  pname = "pysc2";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "pysc2";
    rev = "39f84b01d662eb58b3d95791f59208c210afd4e7";
    sha256 = "0dfbc2krd2rys1ji75ng2nl0ki8nhnylxljcp287bfb8qyz2m25p";
  };

  patches = [
    ./fix-setup-for-py3.patch
    ./parameterize-runconfig-sc2path.patch
  ];

  postPatch = ''
    substituteInPlace "./pysc2/run_configs/platforms.py" \
      --subst-var-by 'sc2path' '${sc2-headless}'
  '';

  propagatedBuildInputs = [
    absl-py
    enum34
    future
    mock
    mpyq
    numpy
    portpicker
    protobuf
    pygame
    s2clientprotocol
    six
    websocket-client
    sc2-headless
  ];

  meta = {
    description = "Starcraft II environment and library for training agents";
    homepage = "https://github.com/deepmind/pysc2";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
