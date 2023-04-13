{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-extensions
, heapdict
, pytestCheckHook
, pythonOlder
}: buildPythonPackage rec {
  pname = "cachey";
  version = "0.2.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";
  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-5USmuufrrWtmgibpfkjo9NtgN30hdl8plJfythmxM4s=";
  };
  propagatedBuildInputs = [ typing-extensions heapdict ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [
    "cachey"
  ];
  meta = with lib; {
    description = "Caching based on computation time and storage space";
    homepage = "https://github.com/dask/cachey/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
