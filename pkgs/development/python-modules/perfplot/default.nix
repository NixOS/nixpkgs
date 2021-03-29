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
  version = "0.8.9";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "perfplot";
    rev = "v${version}";
    sha256 = "0vapd663sbk2jakpgm9gs52rk1cynf0xkin6lf2b1wyyg66ypnk4";
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
