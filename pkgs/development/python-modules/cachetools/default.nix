{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cachetools";
  version = "4.2.1";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "tkem";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b662ph8m2d05d2vi3izgnr6v7h9zfvscfsaaw8nhdmmm15ivfa6";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cachetools" ];

  meta = with lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
