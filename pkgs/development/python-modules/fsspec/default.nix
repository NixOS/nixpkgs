{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytest
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "0.6.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "intake";
    repo = "filesystem_spec";
    rev = version;
    sha256 = "1y3d6xw14rcldz9779ir6mjaff4rk82ch6ahn4y9mya0qglpc31i";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A specification that python filesystems should adhere to";
    homepage = https://github.com/intake/filesystem_spec;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
