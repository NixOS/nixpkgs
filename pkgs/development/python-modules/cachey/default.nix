{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  typing-extensions,
  heapdict,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "cachey";
  version = "0.2.1";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "dask";
    repo = "cachey";
    rev = version;
    hash = "sha256-5USmuufrrWtmgibpfkjo9NtgN30hdl8plJfythmxM4s=";
  };
  propagatedBuildInputs = [
    typing-extensions
    heapdict
  ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "cachey" ];
  meta = {
    description = "Caching based on computation time and storage space";
    homepage = "https://github.com/dask/cachey/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
