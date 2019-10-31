{ stdenv, buildPythonPackage, fetchFromGitHub, isPy27
, cookiecutter, networkx , pandas, tornado, tqdm
, pytest }:

buildPythonPackage rec {
  pname = "mesa";
  version = "0.8.6";

  # According to their docs, this library is for Python 3+.
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "projectmesa";
    repo = "mesa";
    rev = "v${version}";
    sha256 = "0d8c636zhswxd91ldlmdxxlyym2fj3bk1iqmpc1jp3hg7vvc7w03";
  };

  checkInputs = [ pytest ];

  # Ignore test which tries to mkdir in unreachable location.
  checkPhase = ''
    pytest tests -k "not scaffold"
  '';

  propagatedBuildInputs = [ cookiecutter networkx pandas tornado tqdm ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/projectmesa/mesa";
    description = "An agent-based modeling (or ABM) framework in Python";
    license = licenses.asl20;
    maintainers = [ maintainers.dpaetzel ];
  };
}
