{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "async-dns";
  version = "1.1.9";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "gera2ld";
    repo = "async_dns";
    rev = "v${version}";
    sha256 = "1z8j0s3dwcyavarhx41q75k1cmfzmwiqdh4svv3v15np26cywyag";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  patches = [
    # Switch to poetry-core, https://github.com/gera2ld/async_dns/pull/22
    # Can be remove for async-dns>1.1.9
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/gera2ld/async_dns/commit/25fee497aae3bde0ddf9f8804d249a27edbe607e.patch";
      sha256 = "0w4zlppnp1a2q1wasc95ymqx3djswl32y5nw6fvz3nn8jg4gc743";
    })
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
