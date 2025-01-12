{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libyaml,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "yaml-filter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "OpenSCAP";
    repo = "yaml-filter";
    rev = "v${version}";
    hash = "sha256-HDHjOapMFjuDcWW5+opKD2tllbwz4YBw/EI4W7Wf/6g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libyaml ];

  meta = {
    description = "YAML document filtering for libyaml";
    homepage = "https://github.com/OpenSCAP/yaml-filter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "yamlp";
    platforms = lib.platforms.all;
  };
}
