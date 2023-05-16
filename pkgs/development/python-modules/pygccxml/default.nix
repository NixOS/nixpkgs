<<<<<<< HEAD
{ lib
, castxml
, fetchFromGitHub
, buildPythonPackage
, llvmPackages
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygccxml";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gccxml";
    repo = "pygccxml";
    rev = "refs/tags/v${version}";
    hash = "sha256-+cmp41iWbkUSLNFLvEPHocpTQAX2CpD8HMXLIYcy+8k=";
  };

  buildInputs = [
    castxml
    llvmPackages.libcxxStdenv
  ];
=======
{ lib, castxml, fetchFromGitHub, buildPythonPackage,
llvmPackages }:
buildPythonPackage rec {
  pname = "pygccxml";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner  = "gccxml";
    repo   = "pygccxml";
    rev    = "v${version}";
    sha256 = "1msqpg3dqn7wjlf91ddljxzz01a3b1p2sy91n36lrsy87lz499gh";
  };

  buildInputs = [ castxml llvmPackages.libcxxStdenv];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # running the suite is hard, needs to generate xml_generator.cfg
  # but the format doesn't accept -isystem directives
  doCheck = false;

  meta = with lib; {
<<<<<<< HEAD
    description = "Python package for easy C++ declarations navigation";
    homepage = "https://github.com/gccxml/pygccxml";
    changelog = "https://github.com/CastXML/pygccxml/blob/v${version}/CHANGELOG.md";
=======
    homepage = "https://github.com/gccxml/pygccxml";
    description = "Python package for easy C++ declarations navigation";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.boost;
    maintainers = with maintainers; [ teto ];
  };
}
