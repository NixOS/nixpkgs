{
  buildPythonPackage,
  eval-type-backport,
  fetchFromGitHub,
  httpx,
  invoke,
  lib,
  orjson,
  poetry-core,
  pydantic,
  python-dateutil,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "mistralai";
  version = "1.9.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "client-python";
    rev = "v${version}";
    sha256 = "sha256-34+HK4kTY1fcNWqiEJ/j5CA3xynO9DO3TCblndAJmmg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "README-PYPI.md" "README.md"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    eval-type-backport
    httpx
    invoke
    orjson
    pydantic
    python-dateutil
    pyyaml
  ];

  meta = with lib; {
    description = "The Mistral AI Python client";
    homepage = "https://github.com/mistralai/client-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
