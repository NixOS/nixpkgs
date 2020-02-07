{ lib
, buildPythonPackage
, fetchFromGitHub
, pandas
, prompt_toolkit
, pycurl
, pygments
, pytest
, pytestrunner
, requests
, six
, sqlalchemy
, tabulate
, tornado
}:

buildPythonPackage rec {
  pname = "pydruid";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "druid-io";
    repo = pname;
    rev = version;
    sha256 = "0zb6zmklib26fzv5dvqzy0h0p1ljjgkklnjm66imc35mx5irpzcv";
  };

  patchPhase = ''
    # timestamp is added to the end of the list, and dict keeps keys in insertion order
    substituteInPlace tests/test_query.py --replace  \
      "def expected_results_csv_reader():" "
    EXPECTED_RESULTS_PANDAS = list(map(lambda x: dict(list(x.items())[1:] + [list(x.items())[0]]), EXPECTED_RESULTS_PANDAS))
    def expected_results_csv_reader():"
  '';
 
  propagatedBuildInputs = [ pandas prompt_toolkit pycurl pygments requests six sqlalchemy tabulate tornado ];

  checkInputs = [ pytest pytestrunner ];
  
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "A Python connector for Druid";
    homepage = "https://github.com/druid-io/pydruid";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
