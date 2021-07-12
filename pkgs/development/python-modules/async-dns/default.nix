{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "async-dns";
  version = "1.1.10";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "gera2ld";
    repo = "async_dns";
    rev = "v${version}";
    sha256 = "1yxmdlf2n66kp2mprsd4bvfsf63l4c4cfkjm2rm063pmlifz2fvj";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkPhase = ''
    export HOME=$TMPDIR
    # Test needs network access
    rm tests/test_resolver.py
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
