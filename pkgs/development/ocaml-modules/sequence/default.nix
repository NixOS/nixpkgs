{ stdenv, fetchFromGitHub, buildDunePackage, qtest, result }:

buildDunePackage rec {
  pname = "sequence";
  version = "1.1";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = version;
    sha256 = "08j37nldw47syq3yw4mzhhvya43knl0d7biddp0q9hwbaxhzgi44";
  };

  buildInputs = [ qtest ];
  propagatedBuildInputs = [ result ];

  doCheck = true;

  meta = {
    homepage = https://github.com/c-cube/sequence;
    description = "Simple sequence (iterator) datatype and combinators";
    longDescription = ''
      Simple sequence datatype, intended to transfer a finite number of
      elements from one data structure to another. Some transformations on sequences,
      like `filter`, `map`, `take`, `drop` and `append` can be performed before the
      sequence is iterated/folded on.
    '';
    license = stdenv.lib.licenses.bsd2;
  };
}
