{ lib
, buildPythonPackage
, fetchFromGitHub
, dufte
, matplotlib
, numpy
, pipdate
, tqdm
, rich
, pytest
, isPy27
}:

buildPythonPackage rec {
  pname = "perfplot";
  version = "0.8.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "perfplot";
    rev = "v${version}";
    sha256 = "0avb0inx8qh8ss3j460v3z6mmn863hswa3bl19vkh475ndsjwmp0";
  };
  format = "pyproject";

  propagatedBuildInputs = [
    dufte
    matplotlib
    numpy
    pipdate
    rich
    tqdm
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    export HOME=$TMPDIR
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
    pytest test/perfplot_test.py
  '';

  meta = with lib; {
    description = "Performance plots for Python code snippets";
    homepage = "https://github.com/nschloe/perfplot";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
