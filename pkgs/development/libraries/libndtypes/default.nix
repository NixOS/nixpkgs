{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "libndtypes-${version}";
  version = "0.2.0dev3";

  src = fetchFromGitHub {
    owner = "plures";
    repo = "ndtypes";
    rev = "v${version}";
    sha256 = "0dpvv13mrid8l5zkjlz18qvirz3nr0v98agx9bcvkqbiahlfgjli";
  };

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [ "LD=${stdenv.cc.targetPrefix}cc" ];

  meta = {
    description = "Dynamic types for data description and in-memory computations";
    homepage = https://xnd.io/;
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
