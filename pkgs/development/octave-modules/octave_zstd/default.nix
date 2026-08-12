{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  # Pkg deps
  zstd,
  # Octave deps
  octave_tar,
}:

buildOctavePackage rec {
  pname = "octave_zstd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "CNOCTAVE";
    repo = "octave_zstd";
    tag = version;
    sha256 = "sha256-h/3PXYZabCe+gpBRJLS2xnvKtZPI1MKtk0Xg7QaPK9E=";
  };

  buildInputs = [ zstd ];

  requiredOctavePackages = [ octave_tar ];

  postPatch = ''
    chmod +x src/configure
  '';

  meta = {
    homepage = "https://gnu-octave.github.io/packages/octave_zstd/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    description = "The octave_zstd package provides functions for compress and decompress about ZSTD format.";
  };
}
