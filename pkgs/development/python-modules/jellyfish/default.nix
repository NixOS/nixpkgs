{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, unicodecsv
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "0.8.9";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "90d25e8f5971ebbcf56f216ff5bb65d6466572b78908c88c47ab588d4ea436c2";
  };

  checkInputs = [ pytest unicodecsv ];

  meta = {
    homepage = "https://github.com/sunlightlabs/jellyfish";
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
