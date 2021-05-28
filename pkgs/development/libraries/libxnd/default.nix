{ lib
, stdenv
, fetchFromGitHub
, libndtypes
}:

stdenv.mkDerivation {
  pname = "libxnd";
  version = "unstable-2019-08-01";

  src = fetchFromGitHub {
    owner = "xnd-project";
    repo = "xnd";
    rev = "6f305cd40d90b4f3fc2fe51ae144b433d186a6cc";
    sha256 = "1n31d64qwlc7m3qkzbafhp0dgrvgvkdx89ykj63kll7r1n3yk59y";
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

  # other packages which depend on libxnd seem to expect overflow.h, but
  # it doesn't seem to be included in the installed headers. for now this
  # works, but the generic name of the header could produce problems
  # with collisions down the line.
  postInstall = ''
    cp libxnd/overflow.h $out/include/overflow.h
  '';

  doCheck = true;

  meta = {
    description = "C library for managing typed memory blocks and Python container module";
    homepage = "https://xnd.io/";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
