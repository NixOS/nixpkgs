{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, cryptography
, jinja2
, Mako
, passlib
, pytest
, pyyaml
, requests
, rtoml
, setuptools
, tomlkit
, librouteros
}:

buildPythonPackage rec {
  pname = "bundlewrap";
  version = "4.15.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bundlewrap";
    repo = "bundlewrap";
    rev = "${version}";
    sha256 = "sha256-O31lh43VyaFnd/IUkx44wsgxkWubZKzjsKXzHwcGox0";
  };

  propagatedBuildInputs = [
    cryptography jinja2 Mako passlib pyyaml requests setuptools tomlkit librouteros
  ] ++ lib.optional (pythonOlder "3.11") [ rtoml ];

  pythonImportsCheck = [ pname ];

  checkInputs = [ pytest ];

  checkPhase = ''
    # only unit tests as integration tests need a OpenSSH client/server setup
    py.test tests/unit
  '';

  meta = with lib; {
    homepage = "https://bundlewrap.org/";
    description = "Easy, Concise and Decentralized Config management with Python";
    license = [ licenses.gpl3 ] ;
    maintainers = with maintainers; [ wamserma ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
