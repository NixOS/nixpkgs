{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deepfilter-ladspa";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "Rikorose";
    repo = "DeepFilterNet";
    rev = "v${version}";
    hash = "sha256-+RngJjMtHQC91ctIgHALHss7qSB9pBYLNehKaTOwNTA=";
  };

  cargoLock = {
    # lockfile from https://raw.githubusercontent.com/Rikorose/DeepFilterNet/v0.5.3/Cargo.lock
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hdf5-0.8.1" = "sha256-TQaIgu2ww/2HTaJC7q/lLWjTdSwIJ2G2RvO0WS5mfcM=";
    };
  };

  # libDF has ![feature(get_mut_unchecked)]
  RUSTC_BOOTSTRAP = 1;

  buildAndTestSubdir = "ladspa";

  postInstall = ''
    mkdir $out/lib/ladspa
    mv $out/lib/libdeep_filter_ladspa.so $out/lib/ladspa/libdeep_filter_ladspa.so
  '';

  meta = {
    description = "Noise supression using deep filtering (LADSPA plugin)";
    homepage = "https://github.com/Rikorose/DeepFilterNet";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ ralismark ];
    platforms = lib.platforms.all;
  };
}
