{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  pythonAtLeast,
  poetry-core,

  # propagates
  pylev,
  pastel,

  # python36+
  crashtest,

  # python2
  typing,
  enum34,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "clikit";
  version = "0.6.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sdispater";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xAsUNhVQBjtSFHyjjnicAKRC3+Tdn3AdGDUYhmOOIdA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace \
      'crashtest = { version = "^0.3.0", python = "^3.6" }' \
      'crashtest = { version = "*", python = "^3.6" }'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs =
    [
      pylev
      pastel
    ]
    ++ lib.optionals (pythonAtLeast "3.6") [ crashtest ]
    ++ lib.optionals isPy27 [
      typing
      enum34
    ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "clikit" ];

  meta = with lib; {
    homepage = "https://github.com/sdispater/clikit";
    description = "Group of utilities to build beautiful and testable command line interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
