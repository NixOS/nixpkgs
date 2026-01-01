{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  multiprocess,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "btest";
  version = "1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "btest";
    tag = "v${version}";
    hash = "sha256-c+iWzqq0RiRkZlRYjUCXIaFqgnyFdbMAWDNrVYZUvgw=";
  };

  build-system = [ setuptools ];

  dependencies = [ multiprocess ];

  # No tests available and no module to import
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Generic Driver for Powerful System Tests";
    homepage = "https://github.com/zeek/btest";
    changelog = "https://github.com/zeek/btest/blob/${src.tag}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Generic Driver for Powerful System Tests";
    homepage = "https://github.com/zeek/btest";
    changelog = "https://github.com/zeek/btest/blob/${src.tag}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
