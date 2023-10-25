{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, scipy
, pythonOlder
}:

buildPythonPackage {
  pname = "fastpair";
  version = "unstable-2021-05-19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "carsonfarmer";
    repo = "fastpair";
    rev = "d3170fd7e4d6e95312e7e1cb02e84077a3f06379";
    hash = "sha256-vSb6o0XvHlzev2+uQKUI66wM39ZNqDsppEc8rlB+H9E=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    scipy
  ];

  meta = with lib; {
    description = "Data-structure for the dynamic closest-pair problem";
    homepage = "https://github.com/carsonfarmer/fastpair";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai rakesh4g ];
  };
}
