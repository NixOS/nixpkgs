{ buildPythonPackage, lib, fetchFromGitHub
, networkx, numpy, scipy, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "geometric";
  version = "0.9.7.2";

  src = fetchFromGitHub {
    owner = "leeping";
    repo = "geomeTRIC";
    rev = version;
    hash = "sha256-QFpfY6tWqcda6AJT17YBEuwu/4DYPbIMJU1c9/gHjaA=";
  };

  propagatedBuildInputs = [
    networkx
    numpy
    scipy
    six
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Geometry optimization code for molecular structures";
    homepage = "https://github.com/leeping/geomeTRIC";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.markuskowa ];
  };
}

