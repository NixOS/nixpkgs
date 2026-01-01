{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchFromGitHub,
  pudb,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "recline";
<<<<<<< HEAD
  version = "2025.12";
=======
  version = "2025.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NetApp";
    repo = "recline";
    tag = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-xEH6fEq84nD3X6bPj1Yw36mjwHKlFKsVaMh4Iogzl18=";
=======
    sha256 = "sha256-WBMt5jDPCBmTgVdYDN662uU2HVjB1U3GYJwn0P56WsI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [ argcomplete ];

  nativeCheckInputs = [
    pudb
    pytestCheckHook
  ];

  pythonImportsCheck = [ "recline" ];

<<<<<<< HEAD
  meta = {
    description = "This library helps you quickly implement an interactive command-based application";
    homepage = "https://github.com/NetApp/recline";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "This library helps you quickly implement an interactive command-based application";
    homepage = "https://github.com/NetApp/recline";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
