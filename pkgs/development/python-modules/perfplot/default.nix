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
  version = "0.8.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "perfplot";
    rev = "v${version}";
    sha256 = "0avb0inx8qh8ss3j460v3z6mmn863hswa3bl19vkh475ndsjwmp0";
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
    homepage = "https://github.com/nschloe/perfplot";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
