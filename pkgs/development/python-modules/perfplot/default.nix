{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, pipdate
, tqdm
, pytest
, isPy27
}:

buildPythonPackage rec {
  pname = "perfplot";
  version = "0.5.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "perfplot";
    rev = "v${version}";
    sha256 = "16aj5ryjic1k3qn8xhpw6crczvxcs691vs5kv4pvb1zdx69g1xbv";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    pipdate
    tqdm
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
   HOME=$(mktemp -d) pytest test/perfplot_test.py
  '';

  meta = with lib; {
    description = "Performance plots for Python code snippets";
    homepage = https://github.com/nschloe/perfplot;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
