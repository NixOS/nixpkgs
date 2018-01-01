{ lib
, buildPythonPackage
, fetchPypi
, pytest
, unicodecsv
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "887a9a49d0caee913a883c3e7eb185f6260ebe2137562365be422d1316bd39c9";
  };

  checkInputs = [ pytest unicodecsv ];

  meta = {
    homepage = https://github.com/sunlightlabs/jellyfish;
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
