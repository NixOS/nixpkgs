{ lib
, buildPythonPackage
, fetchPypi
, pytest
, unicodecsv
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5104e45a2b804b48a46a92a5e6d6e86830fe60ae83b1da32c867402c8f4c2094";
  };

  checkInputs = [ pytest unicodecsv ];

  meta = {
    homepage = https://github.com/sunlightlabs/jellyfish;
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
