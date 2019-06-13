{ lib
, stdenv
, fetchFromGitHub
, libndtypes
}:

stdenv.mkDerivation rec {
  name = "libxnd-${version}";
  version = "unstable-2018-11-27";

  src = fetchFromGitHub {
    owner = "plures";
    repo = "xnd";
    rev = "8a9f3bd1d01d872828b40bc9dbd0bc0184524da3";
    sha256 = "10jh2kqvhpzwy50adayh9az7z2lm16yxy4flrh99alzzbqdyls44";
  };

  buildInputs = [ libndtypes ];

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [
      # Override linker with cc (symlink to either gcc or clang)
      # Library expects to use cc for linking
      "LD=${stdenv.cc.targetPrefix}cc"
      # needed for tests
      "--with-includes=${libndtypes}/include"
      "--with-libs=${libndtypes}/lib"
  ];

  doCheck = true;

  meta = {
    description = "C library for managing typed memory blocks and Python container module";
    homepage = https://xnd.io/;
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
