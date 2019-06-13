{ stdenv
, fetchFromGitHub
, libndtypes
, libxnd
}:

stdenv.mkDerivation rec {
  name = "libgumath-${version}";
  version = "unstable-2018-11-27";

  src = fetchFromGitHub {
    owner = "plures";
    repo = "gumath";
    rev = "5a9d27883b40432246d6a93cd6133157267fd166";
    sha256 = "0w2qzp7anxd1wzkvv5r2pdkkpgrnqzgrq47lrvpqc1i1wqzcwf0w";
  };

  buildInputs = [ libndtypes libxnd ];

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library supporting function dispatch on general data containers. C base and Python wrapper";
    homepage = https://xnd.io/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
