{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, cookiecutter, networkx , pandas, tornado, tqdm
, pytest }:

buildPythonPackage rec {
  pname = "mesa";
  version = "1.1.1";

  # According to their docs, this library is for Python 3+.
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "projectmesa";
    repo = "mesa";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-6EVxhRRR0qmwsKlFeD/U89uolfNxgXd66doDDTxsvS4=";
  };

  checkInputs = [ pytest ];

  # Ignore test which tries to mkdir in unreachable location.
  checkPhase = ''
    pytest tests -k "not scaffold"
  '';

  propagatedBuildInputs = [ cookiecutter networkx pandas tornado tqdm ];

  meta = with lib; {
    homepage = "https://github.com/projectmesa/mesa";
    description = "An agent-based modeling (or ABM) framework in Python";
    license = licenses.asl20;
    maintainers = [ maintainers.dpaetzel ];
  };
}
