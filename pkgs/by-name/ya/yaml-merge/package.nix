{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "yaml-merge";
  version = "unstable-2022-01-12";

  src = fetchFromGitHub {
    owner = "abbradar";
    repo = "yaml-merge";
    rev = "2f0174fe92fc283dd38063a3a14f7fe71db4d9ec";
    sha256 = "sha256-S2eZw+FOZvOn0XupZDRNcolUPd4PhvU1ziu+kx2AwnY=";
  };

  pythonPath = with python3Packages; [ pyyaml ];
  nativeBuildInputs = with python3Packages; [ wrapPython ];

  installPhase = ''
    install -Dm755 yaml-merge.py $out/bin/yaml-merge
    wrapPythonPrograms
  '';

  meta = {
    description = "Merge YAML data files";
    mainProgram = "yaml-merge";
    homepage = "https://github.com/abbradar/yaml-merge";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
