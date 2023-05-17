{ lib, buildPythonPackage, fetchFromGitHub, pytest-runner, pytest, scipy, pytestCheckHook }:

buildPythonPackage {
  pname = "fastpair";
  version = "2021-05-19";

  src = fetchFromGitHub {
    owner = "carsonfarmer";
    repo = "fastpair";
    rev = "d3170fd7e4d6e95312e7e1cb02e84077a3f06379";
    sha256 = "1l8zgr8awg27lhlkpa2dsvghrb7b12jl1bkgpzg5q7pg8nizl9mx";
  };

  nativeBuildInputs = [ pytest-runner ];

  nativeCheckInputs = [ pytest pytestCheckHook ];

  propagatedBuildInputs = [
    scipy
  ];

  meta = with lib; {
    homepage = "https://github.com/carsonfarmer/fastpair";
    description = "Data-structure for the dynamic closest-pair problem";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai rakesh4g ];
  };
}
