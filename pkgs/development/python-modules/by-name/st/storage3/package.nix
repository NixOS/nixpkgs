{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  python-dateutil,
  httpx,
  h2,
  deprecation,
}:

buildPythonPackage rec {
  pname = "storage3";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "storage-py";
    tag = "v${version}";
    hash = "sha256-Ef309CTnzbaqKAVMdvroUYAy9RImWZZqhsnwRdpGVkk=";
  };

  dependencies = [
    python-dateutil
    httpx
    h2
    deprecation
  ];

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "storage3" ];

  # tests fail due to mock server not starting

  meta = {
    homepage = "https://github.com/supabase/storage-py";
    license = lib.licenses.mit;
    description = "Supabase Storage client for Python.";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
