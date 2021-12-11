{ lib
, buildPythonPackage
, environs
, fetchFromGitHub
, poetry-core
, pytest-mock
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
, tornado
}:

buildPythonPackage rec {
  pname = "deezer-python";
  version = "4.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wljf3ri8jcg4df6m61k8s5nm9rncwa8c46pfv901bc737kyslpl";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    environs
    pytest-mock
    pytest-vcr
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    requests
    tornado
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=deezer" ""
  '';

  pythonImportsCheck = [ "deezer" ];

  meta = with lib; {
    description = "Python wrapper around the Deezer API";
    homepage = "https://github.com/browniebroke/deezer-python";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
  };
}
