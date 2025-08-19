{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "py-dormakaba-dkey";
  version = "1.0.6";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = "py-dormakaba-dkey";
    tag = version;
    hash = "sha256-WAptkdMXZN3IKjXGBiILN4gJWdVEndfGndc6J2R2cD0=";
  };

  patches = [
    # https://github.com/emontnemery/py-dormakaba-dkey/pull/45
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/emontnemery/py-dormakaba-dkey/commit/cfda4be71d39f2cfd1c0d4f7fff9018050c57f1a.patch";
      hash = "sha256-JGsaLQNbUfz0uK/MeGnR2XTJDs4RnTOEg7BavfDPArg=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    cryptography
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "py_dormakaba_dkey" ];

  meta = with lib; {
    description = "Library to interact with a Dormakaba dkey lock";
    homepage = "https://github.com/emontnemery/py-dormakaba-dkey";
    changelog = "https://github.com/emontnemery/py-dormakaba-dkey/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
