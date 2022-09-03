{ lib
, fetchFromGitHub
, buildPythonPackage
, tzlocal
, six
, pyjsparser
}:

buildPythonPackage rec {
  pname = "js2py";
  version = "0.71";

  src = fetchFromGitHub {
    owner = "PiotrDabkowski";
    repo = "Js2Py";
    rev = "5f665f60083a9796ec33861240ce31d6d2b844b6";
    sha256 = "sha256-1omTV7zkYSQfxhkNgI4gtXTenWt9J1r3VARRHoRsSfc=";
  };

  propagatedBuildInputs = [
    pyjsparser
    six
    tzlocal
  ];

  # Test require network connection
  doCheck = false;

  pythonImportsCheck = [ "js2py" ];

  meta = with lib; {
    description = "JavaScript to Python Translator & JavaScript interpreter written in 100% pure Python";
    homepage = "https://github.com/PiotrDabkowski/Js2Py";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
