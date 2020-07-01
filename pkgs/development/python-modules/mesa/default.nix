{ stdenv, buildPythonPackage, fetchFromGitHub, isPy27
, cookiecutter, networkx , pandas, tornado, tqdm
, pytest }:

buildPythonPackage rec {
  pname = "mesa";
  # contains several fixes for networkx 2.4 bump
  version = "unstable-2019-12-09";

  # According to their docs, this library is for Python 3+.
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "projectmesa";
    repo = "mesa";
    rev = "86b343b42630e94d939029ff2cc609ff04ed40e9";
    sha256 = "1y41s1vd89vcsm4aia18ayfff4w2af98lwn5l9fcwp157li985vw";
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
