{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkginfo,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "colorzero";
  version = "2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "waveform80";
    repo = "colorzero";
    tag = "release-${version}";
    hash = "sha256-0NoQsy86OHQNLZsTEuF5s2MlRUoacF28jNeHgFKAH14=";
  };

  nativeBuildInputs = [ pkginfo ];

  pythonImportsCheck = [ "colorzero" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = with lib; {
    description = "Yet another Python color library";
    homepage = "https://github.com/waveform80/colorzero";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
