{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  normality,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fingerprints";
  version = "1.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alephdata";
    repo = "fingerprints";
    rev = version;
    hash = "sha256-U2UslCy1OagVTtllCKsEBX4zI/qIczbxs2Cxzy+/Xys=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ normality ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fingerprints" ];

  meta = with lib; {
    description = "Library to generate entity fingerprints";
    homepage = "https://github.com/alephdata/fingerprints";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
