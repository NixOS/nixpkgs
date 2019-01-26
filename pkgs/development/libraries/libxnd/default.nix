{ lib
, stdenv
, fetchFromGitHub
, libndtypes
}:

stdenv.mkDerivation rec {
  name = "libxnd-${version}";
  version = "0.2.0dev3";

  src = fetchFromGitHub {
    owner = "plures";
    repo = "xnd";
    rev = "v${version}";
    sha256 = "0byq7jspyr2wxrhihw4q7nf0y4sb6j5ax0ndd5dnq5dz88c7qqm2";
  };

  buildInputs = [ libndtypes ];

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [ "LD=${stdenv.cc.targetPrefix}cc" ];

  meta = {
    description = "General container that maps a wide range of Python values directly to memory";
    homepage = https://xnd.io/;
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
