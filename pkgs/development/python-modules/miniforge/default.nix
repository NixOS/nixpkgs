{ lib
, stdenv
, fetchFromGitHub
, python3
, conda
}:

stdenv.mkDerivation rec {
  pname = "miniforge";
  version = "24.11.0-0";

  src = fetchFromGitHub {
    owner = "conda-forge";
    repo = "miniforge";
    rev = version;
    sha256 = "sha256-Mtw0TI5LWv7aC2kCx7EStYXEUa9J3xTwUPpN/z9GvAQ=";  # Will be provided by nix-build error
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

  meta = with lib; {
    description = "A conda-forge distribution with mamba 1.5.11";
    homepage = "https://github.com/conda-forge/miniforge";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];  # Add your maintainer handle after PR to nixpkgs-maintainers
  };
}
