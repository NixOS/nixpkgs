{ buildPythonPackage
, fetchFromGitHub
, hyperopt
, lib
, mock
, numpy
, poetry
, prometheus_client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gradient-utils";
  version = "0.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Paperspace";
    repo = pname;
    rev = "v${version}";
    sha256 = "083hnkv19mhvdc8nx28f1nph50c903gxh9g9q8531abv0w8m0744";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'numpy = "1.18.5"' 'numpy = "^1.18.5"' \
      --replace 'hyperopt = "0.1.2"' 'hyperopt = ">=0.1.2"'
  '';

  nativeBuildInputs = [ poetry ];
  checkInputs = [ mock pytestCheckHook ];
  propagatedBuildInputs = [ hyperopt prometheus_client numpy ];

  preCheck = "export HOSTNAME=myhost-experimentId";
  disabledTests = [
    "test_add_metrics_pushes_metrics" # requires a working prometheus push gateway
  ];

  meta = with lib; {
    description = "Gradient ML SDK";
    homepage    = "https://github.com/Paperspace/gradient-utils";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
