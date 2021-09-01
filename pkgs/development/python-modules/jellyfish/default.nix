{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, unicodecsv
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "0.8.8";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0506089cacf9b5897442134417b04b3c6610c19f280ae535eace390dc6325a5c";
  };

  checkInputs = [ pytest unicodecsv ];

  meta = {
    homepage = "https://github.com/sunlightlabs/jellyfish";
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
