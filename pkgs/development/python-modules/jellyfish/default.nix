{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, unicodecsv
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "0.9.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "40c9a2ffd8bd3016f7611d424120442f627f56d518a106847dc93f0ead6ad79a";
  };

  nativeCheckInputs = [ pytest unicodecsv ];

  meta = {
    homepage = "https://github.com/sunlightlabs/jellyfish";
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
