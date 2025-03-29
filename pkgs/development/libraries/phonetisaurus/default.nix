{
  lib,
  stdenv,
  fetchFromGitHub,
  openfst,
  pkg-config,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "phonetisaurus";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "AdolfVonKleist";
    repo = pname;
    rev = version;
    sha256 = "1b18s5zz0l0fhqh9n9jnmgjz2hzprwzf6hx5a12zibmmam3qyriv";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    python3
    openfst
  ];

  meta = with lib; {
    description = "Framework for Grapheme-to-phoneme models for speech recognition using the OpenFst framework";
    inherit (src.meta) homepage;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
