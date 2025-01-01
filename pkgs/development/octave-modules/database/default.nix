{
  buildOctavePackage,
  lib,
  fetchurl,
  struct,
  postgresql,
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
    postgresql
  ];

  requiredOctavePackages = [
    struct
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/database/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Interface to SQL databases, currently only postgresql using libpq";
  };
}
