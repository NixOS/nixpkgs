{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cachetools";
  version = "4.2.2";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "tkem";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JTm8ht2Ubn34uQLR0yjUjXSdDQggWfYUlS0T628OUoI=";
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
