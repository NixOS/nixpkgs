{
  lib,
  buildPythonPackage,
  nettools,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytap2";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "johnthagen";
    repo = "pytap2";
    rev = "v${version}";
    hash = "sha256-GN8yFnS7HVgIP73/nVtYnwwhCBI9doGHLGSOaFiWIdw=";
  };

  propagatedBuildInputs = [ nettools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytap2" ];

  meta = with lib; {
    description = "Object-oriented wrapper around the Linux Tun/Tap device";
    homepage = "https://github.com/johnthagen/pytap2";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
