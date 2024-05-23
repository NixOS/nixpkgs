{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "colorgram-py";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "obskyr";
    repo = "colorgram.py";
    rev = "v${version}";
    hash = "sha256-jF/J6mOklKn+xE38zvFyrPs3WxwRPHGPHXd61b4SkIc=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = [ python3.pkgs.pillow ];

  meta = with lib; {
    description = "A Python module for extracting colors from images. Get a palette of any picture";
    homepage = "https://github.com/obskyr/colorgram.py";
    license = licenses.mit;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "colorgram-py";
  };
}
