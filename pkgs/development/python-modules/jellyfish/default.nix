{ lib
, buildPythonPackage
, fetchPypi
, pytest
, unicodecsv
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15xk0kbr1gig9r1mp22lk9mk3jyi886h8ywn9diixhnyl4q6dacn";
  };

  checkInputs = [ pytest unicodecsv ];

  meta = {
    homepage = https://github.com/sunlightlabs/jellyfish;
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
