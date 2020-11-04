{ buildPythonPackage, isPy3k, lib, fetchFromGitHub, setuptools_scm, toml, pytest }:

buildPythonPackage rec {
  pname = "pure_eval";
  version = "0.1.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d3gpc9mrmwdk6l87x7ll23vwv6l8l2iqvi63r86j7bj5s8m2ci8";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ toml ];

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Safely evaluate AST nodes without side effects";
    homepage = "http://github.com/alexmojaki/pure_eval";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
