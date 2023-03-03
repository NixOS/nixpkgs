{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "doctest";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0hh9izj9ds69bmrvmmj16fd1c4z7733h50c7isl8f714srw26kf4";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/doctest/index.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ KarlJoad ];
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
