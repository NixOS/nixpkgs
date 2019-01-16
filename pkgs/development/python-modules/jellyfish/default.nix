{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, unicodecsv
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "0.7.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hd1xzw22g1cp2dpf5bbpg8a7iac2v9hw0xrj5n5j83inh5n99br";
  };

  checkInputs = [ pytest unicodecsv ];

  meta = {
    homepage = https://github.com/sunlightlabs/jellyfish;
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
