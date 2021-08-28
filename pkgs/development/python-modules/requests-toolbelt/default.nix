{ lib
, buildPythonPackage
, fetchPypi
, requests
, betamax
, mock
, pytest
, pyopenssl
}:

buildPythonPackage rec {
  pname = "requests-toolbelt";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0";
  };

  checkInputs = [ pyopenssl betamax mock pytest ];
  propagatedBuildInputs = [ requests ];

  checkPhase = ''
    # disabled tests access the network
    py.test tests -k "not test_no_content_length_header \
                  and not test_read_file \
                  and not test_reads_file_from_url_wrapper"
  '';

  meta = {
    description = "A toolbelt of useful classes and functions to be used with python-requests";
    homepage = "http://toolbelt.rtfd.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
