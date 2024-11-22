{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  aiohttp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "huisbaasje-client";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dennisschroer";
    repo = "huisbaasje-client";
    rev = "v${version}";
    sha256 = "113aymffyz1nki3a43j5cyj87qa0762j38qlz0wd5px7diwjxsfl";
  };

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "huisbaasje.huisbaasje" ];

  meta = with lib; {
    description = "Client for Huisbaasje";
    homepage = "https://github.com/dennisschroer/huisbaasje-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
