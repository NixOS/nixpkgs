{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "async-dns";
  version = "2.0.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "gera2ld";
    repo = "async_dns";
    rev = "v${version}";
    sha256 = "0vn7hxvpzikd7q61a27fwzal4lwsra2063awyr6fjpy6lh3cjdwf";
  };

  nativeBuildInputs = [ poetry-core ];

  checkPhase = ''
    export HOME=$TMPDIR
    # Test needs network access
    rm -r tests/resolver
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "async_dns" ];

  meta = with lib; {
    description = "Python DNS library";
    homepage = "https://github.com/gera2ld/async_dns";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
