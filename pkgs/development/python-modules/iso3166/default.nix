{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "iso3166";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deactivated";
    repo = "python-iso3166";
    rev = "1d513b96ca4aac39ac46d636a7f317c88043de72";
    hash = "sha256-NbXMY0ch5As9thzkP898On4vyEq+XFKEHGQAKCZO/VM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.12.5,<0.13.0' uv_build
  '';

  build-system = [ uv-build ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iso3166" ];

  meta = {
    description = "Self-contained ISO 3166-1 country definitions";
    homepage = "https://github.com/deactivated/python-iso3166";
    changelog = "https://github.com/deactivated/python-iso3166/blob/${src.rev}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zraexy ];
  };
}
