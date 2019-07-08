{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, unicodecsv
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "0.7.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11jja4wlzcr2pwvp3blj1jg6570zr0mpcm3nzhkbkdrbgq6wa2fb";
  };

  checkInputs = [ pytest unicodecsv ];

  meta = {
    homepage = https://github.com/sunlightlabs/jellyfish;
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
