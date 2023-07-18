{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, matplotlib
, pytestCheckHook
, isPy3k
}:

buildPythonPackage {
  pname = "filterpy";
  version = "unstable-2022-08-23";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "rlabbe";
    repo = "filterpy";
    rev = "3b51149ebcff0401ff1e10bf08ffca7b6bbc4a33";
    hash = "sha256-KuuVu0tqrmQuNKYmDmdy+TU6BnnhDxh4G8n9BGzjGag=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
  ];

  meta = with lib; {
    homepage = "https://github.com/rlabbe/filterpy";
    description = "Kalman filtering and optimal estimation library";
    license = licenses.mit;
    maintainers = [ ];
  };
}
