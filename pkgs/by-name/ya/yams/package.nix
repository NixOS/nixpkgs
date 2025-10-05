{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "yams";
  # nixpkgs-update: no auto update
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Berulacks";
    repo = "yams";
    rev = version;
    sha256 = "1zkhcys9i0s6jkaz24an690rvnkv1r84jxpaa84sf46abi59ijh8";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pyyaml
    psutil
    mpd2
    requests
  ];

  doCheck = false;

  pythonImportsCheck = [ "yams.scrobble" ];

  meta = with lib; {
    homepage = "https://github.com/Berulacks/yams";
    description = "Last.FM scrobbler for MPD";
    mainProgram = "yams";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ccellado ];
  };
}
