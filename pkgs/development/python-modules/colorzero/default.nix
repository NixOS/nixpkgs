{ lib
, buildPythonPackage
, fetchFromGitHub
, pkginfo
, sphinxHook
, sphinx-rtd-theme
, pytestCheckHook
}:


buildPythonPackage rec {
  pname = "colorzero";
  version = "2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "waveform80";
    repo = pname;
    rev = "refs/tags/release-${version}";
    hash = "sha256-0NoQsy86OHQNLZsTEuF5s2MlRUoacF28jNeHgFKAH14=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov" ""
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    pkginfo
    sphinx-rtd-theme
    sphinxHook
  ];

  pythonImportsCheck = [
    "colorzero"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Yet another Python color library";
    homepage = "https://github.com/waveform80/colorzero";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
