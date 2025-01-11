{
  lib,
  buildPythonPackage,
  setuptools,
  click,
  geopy,
  ping3,
  requests,
  tabulate,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "mullvad-closest";
  version = "unstable-2023-07-09";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Ch00k";
    repo = "mullvad-closest";
    rev = "894d2075a520fcad238256725245030374693a16";
    hash = "sha256-scJiYjEmnDDElE5rHdPbnnuNjjRB0/X3vNGLoi2MAmo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    click
    geopy
    ping3
    requests
    tabulate
  ];

  pythonImportsCheck = [ "mullvad_closest" ];

  meta = with lib; {
    description = "Find Mullvad servers with the lowest latency at your location";
    mainProgram = "mullvad-closest";
    homepage = "https://github.com/Ch00k/mullvad-closest";
    license = licenses.unlicense;
    maintainers = with maintainers; [ siraben ];
  };
}
