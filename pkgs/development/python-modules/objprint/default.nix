{ lib
, buildPythonPackage
, setuptools
, fetchFromGitHub, fetchgit }:

buildPythonPackage rec {
  pname = "objprint";
  version = "0.2.3";
  format="pyproject";
  src_repo = fetchgit {
    url = "https://github.com/gaogaotiantian/objprint.git";
    rev = "7920c8601e86e97fe05a807d820121bac00471b7";  # Specify the specific commit, tag, or branch
    sha256 = "sha256-IGYjDdi3JzYk53ITVOhVnm9EDsa+4HXSVtVUE3wQWTo="; # SHA256 hash of the source
  };

  # Extract the specific subdirectory within the repository
  propagatedBuildInputs = [
    setuptools
  ];
  src = src_repo;  # Adjust the path to your desired subdirectory

  meta = with lib; {
    homepage = https://github.com/gaogaotiantian/objprint;
    description = "A library that can print Python objects in human readable format";
    license = licenses.asl20;
  };
}
