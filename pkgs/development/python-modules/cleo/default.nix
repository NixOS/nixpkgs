{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, crashtest
, poetry-core
, pylev
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cleo";
  version = "1.0.0a5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FtGGIRF/tA2OWEjkCFwa1HHg6VY+5E5mAiJC/zjUC1g=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-42966.patch";
      url = "https://github.com/python-poetry/cleo/commit/b5b9a04d2caf58bf7cf94eb7ae4a1ebbe60ea455.patch";
      relative = "src";
      hash = "sha256-nMmRipgQC/w4GIV+VHgKx1xmPm4j+4tR980sROmbfnM=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'crashtest = "^0.3.1"' 'crashtest = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    crashtest
    pylev
  ];

  pythonImportsCheck = [
    "cleo"
    "cleo.application"
    "cleo.commands.command"
    "cleo.helpers"
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/python-poetry/cleo";
    description = "Allows you to create beautiful and testable command-line interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
