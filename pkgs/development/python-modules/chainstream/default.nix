{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "chainstream";
  version = "1.0.2";

  pyproject = true;

  nativeBuildInputs = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-syl107PRwDClB6wpgETCj6PKMNUnq9+uKB7dUydmF7M=";
  };

  pythonImportsCheck = [ "chainstream" ];

  meta = with lib; {
    description = "Chain I/O streams together into a single stream";
    homepage = "https://github.com/rrthomas/chainstream";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ cbley ];
  };
}
