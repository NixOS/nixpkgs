{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  isPy27,
}:

buildPythonPackage rec {
  pname = "aiocontextvars";
  version = "0.2.2";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "fantix";
    repo = "aiocontextvars";
    rev = "v${version}";
    hash = "sha256-s1YhpBLz+YNmUO+0BOltfjr3nz4m6mERszNqlmquTyg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = with lib; {
    description = "Asyncio support for PEP-567 contextvars backport";
    homepage = "https://github.com/fantix/aiocontextvars";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
