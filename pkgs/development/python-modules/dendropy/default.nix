{ lib
, pkgs
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname   = "DendroPy";
  version = "4.4.0";

  # tests are incorrectly packaged in pypi version
  src = fetchFromGitHub {
    owner = "jeetsukumaran";
    repo = pname;
    rev = "v${version}";
    sha256 = "097hfyv2kaf4x92i4rjx0paw2cncxap48qivv8zxng4z7nhid0x9";
  };

  preCheck = ''
    # Needed for unicode python tests
    export LC_ALL="en_US.UTF-8"
    cd tests  # to find the 'support' module
  '';

  checkInputs = [ pytest pkgs.glibcLocales ];

  checkPhase = ''
    pytest -k 'not test_dataio_nexml_reader_tree_list and not test_pscores_with'
  '';

  meta = {
    homepage = https://dendropy.org/;
    description = "A Python library for phylogenetic computing";
    maintainers = with lib.maintainers; [ unode ];
    license = lib.licenses.bsd3;
  };
}
