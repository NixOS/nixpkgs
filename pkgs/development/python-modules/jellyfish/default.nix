{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, unicodecsv
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "0.8.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02q3d9b933hf8lyvg7w7lgmhij8bjs748vjmsfxhabai04a796d4";
  };

  checkInputs = [ pytest unicodecsv ];

  meta = {
    homepage = "https://github.com/sunlightlabs/jellyfish";
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
