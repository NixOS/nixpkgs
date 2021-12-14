{ buildPythonPackage
, fetchFromGitHub
, lib
, matplotlib
, palettable
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mizani";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = pname;
    rev = "v${version}";
    sha256 = "04r53dp5jbklv8l9ncgc5wiq0gx25y73h65gmmbbfkxwgsl3w78l";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace " --cov=mizani --cov-report=xml" ""
  '';

  propagatedBuildInputs = [ matplotlib palettable pandas ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mizani" ];

  meta = with lib; {
    description = "Scales for Python";
    homepage = "https://github.com/has2k1/mizani";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
