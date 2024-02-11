{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "libndtypes";
  version = "unstable-2019-08-01";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "xnd-project";
    repo = "ndtypes";
    rev = "3ce6607c96d8fe67b72cc0c97bf595620cdd274e";
    sha256 = "18303q0jfar1lmi4krp94plczb455zcgw772f9lb8xa5p0bkhx01";
  };

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [ "LD=${stdenv.cc.targetPrefix}cc" ];

  doCheck = true;

  meta = with lib; {
    description = "Dynamic types for data description and in-memory computations";
    homepage = "https://xnd.io/";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
