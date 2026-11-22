{
  lib,
  mkDerivation,
  fetchFromGitHub,
  standard-library,
  standard-library-classes,
}:

mkDerivation rec {
  pname = "standard-library-meta";
  version = "2.4";

  libraryFile = "agda-stdlib-meta.agda-lib";

  src = fetchFromGitHub {
    repo = "agda-stdlib-meta";
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-glzhBrOMHHxHrulNyW+5Tnz4MJNkYjvTJhGF/XYoTR8=";
  };

  buildInputs = [
    standard-library
    standard-library-classes
  ];

  meta = {
    homepage = "https://github.com/agda/agda-stdlib-meta";
    description = "Meta-programming utilities for Agda";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      carlostome
    ];
  };
}
