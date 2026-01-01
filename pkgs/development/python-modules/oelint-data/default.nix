{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  oelint-parser,
}:

buildPythonPackage rec {
  pname = "oelint-data";
<<<<<<< HEAD
  version = "1.2.11";
=======
  version = "1.2.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-data";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Verxvo81rFphT1fV6fs6JaVM/kSVqni9Zn5rq5Yq3rU=";
=======
    hash = "sha256-V72XANJnBX0Pcn8fyF7hrI9O117VmOhxVCBt9F1ZJoA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    oelint-parser
  ];

  pythonImportsCheck = [ "oelint_data" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Data for oelint-adv";
    homepage = "https://github.com/priv-kweihmann/oelint-data";
    changelog = "https://github.com/priv-kweihmann/oelint-data/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
