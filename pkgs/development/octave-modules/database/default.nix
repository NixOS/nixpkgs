{
  buildOctavePackage,
  lib,
  fetchurl,
  struct,
  libpq,
}:

buildOctavePackage rec {
  pname = "database";
  version = "2.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1c0n76adi0jw6bx62s04vjyda6kb6ca8lzz2vam43vdy10prcq9p";
  };
  patches = [
    # Fix for octave 8.x
    ./c_verror.patch
  ];

  propagatedBuildInputs = [
    libpq
  ];

  nativeBuildInputs = [
    libpq.pg_config
  ];

  requiredOctavePackages = [
    struct
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/database/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Interface to SQL databases, currently only postgresql using libpq";
  };
}
