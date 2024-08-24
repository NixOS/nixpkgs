{
  lib,
  buildPythonPackage,
  setuptools,
  wheel,
  fetchFromGitLab,
  pkgs,
  dpkg,
}:

buildPythonPackage rec {
  pname = "apt";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "apt-team";
    repo = "python-apt";
    rev = version;
    hash = "sha256-7l7rgyJ28iQuL6ShF/KYwL/kAXpLPTqnUIavVxNF+wU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  buildInputs = [
    pkgs.apt
  ];

  nativeBuildInputs = [
    # dpkg-parsechangelog for setup.py
    dpkg
  ];

  meta = {
    description = "apt module for python";
    homepage = "https://salsa.debian.org/apt-team/python-apt.git";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mkg20001 ];
  };
}
