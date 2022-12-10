{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, amazon-ion, six, pytestCheckHook }:

buildPythonPackage rec {
  pname = "ionhash";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "ion-hash-python";
    rev = "v${version}";
    sha256 = "sha256-mXOLKXauWwwIA/LnF4qyZsBiF/QM+rF9MmE2ewmozYo=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/amzn/ion-hash-python/commit/5cab56d694ecc176e394bb455c2d726ba1514ce0.patch";
      sha256 = "sha256-P5QByNafgxI//e3m+b0oG00+rVymCsT/J4dOZSk3354=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [ amazon-ion six ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ionhash" ];

  meta = with lib; {
    description = "Python implementation of Amazon Ion Hash";
    homepage = "https://github.com/amzn/ion-hash-python";
    license = licenses.asl20;
    maintainers = [ maintainers.terlar ];
  };
}
