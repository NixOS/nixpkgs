{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, ujson
, email_validator
, typing-extensions
, python
, isPy3k
, pytest
, pytestcov
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.5.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fwrx7p6d5vskg9ibganahiz9y9299idvdmzhjw62jy84gn1vrb4";
  };

  # fix tests, remove on next version bump
  patches = [
    (fetchpatch {
      url = "https://github.com/samuelcolvin/pydantic/commit/a5b0e741e585040a0ab8b0be94dd9dc2dd3afcc7.patch";
      sha256 = "0v91ac3dw23rm73370s2ns84vi0xqbfzpvj84zb7xdiicx8fhmf1";
    })
  ];

  propagatedBuildInputs = [
    ujson
    email_validator
    typing-extensions
  ];

  checkInputs = [
    pytest
    pytestcov
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/samuelcolvin/pydantic";
    description = "Data validation and settings management using Python type hinting";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
