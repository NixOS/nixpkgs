{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "gsm0338";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dsch";
    repo = "gsm0338";
    rev = "1c036bd3b656b5075fdc221cbc578c4a47b42b1f";
    hash = "sha256-EkUVd4d4Te8brHerygDc6KQSpiX11NrHYkcZSDRi05w=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gsm0338" ];

  meta = {
    description = "Python codec for GSM 03.38";
    homepage = "https://github.com/dsch/gsm0338";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
