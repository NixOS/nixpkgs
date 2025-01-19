{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkginfo,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorzero";
  version = "2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "waveform80";
    repo = pname;
    tag = "release-${version}";
    hash = "sha256-0NoQsy86OHQNLZsTEuF5s2MlRUoacF28jNeHgFKAH14=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [ pkginfo ];

  pythonImportsCheck = [ "colorzero" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Yet another Python color library";
    homepage = "https://github.com/waveform80/colorzero";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
