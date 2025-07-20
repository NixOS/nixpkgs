{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "doctest";
  version = "0.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-/oXJ7NnbbdsVfhNOYU/tkkYwKhYs5zKMEjybmbf0Cok=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/doctest/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Find and run example code within documentation";
    longDescription = ''
      Find and run example code within documentation. Formatted blocks
      of example code are extracted from documentation files and executed
      to confirm their output is correct. This can be part of a testing
      framework or simply to ensure that documentation stays up-to-date
      during software development.
    '';
  };
}
