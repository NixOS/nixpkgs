{
  lib,
  buildPythonPackage,
  stdenv,
  fetchFromGitHub,
  python3,
  conda,
}:

stdenv.mkDerivation rec {
  pname = "miniforge";
  version = "24.11.0-0";

  src = fetchFromGitHub {
    owner = "conda-forge";
    repo = "miniforge";
    rev = version;
    hash = "sha256-Mtw0TI5LWv7aC2kCx7EStYXEUa9J3xTwUPpN/z9GvAQ=";
  };

  buildInputs = [
    python3
    conda
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
    ln -s $out/miniforge3/bin/conda $out/bin/miniforge-conda
  '';

  meta = {
    description = "Conda-forge distribution with mamba";
    homepage = "https://github.com/conda-forge/miniforge";
    license =  with licenses; [ bsd3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ qxrein ];
  };
}
