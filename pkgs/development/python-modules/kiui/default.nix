{
  lib,
  buildPythonPackage,
  varname,
  lazy-loader,
  objprint,
  setuptools,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "kiui";
  version = "0.2.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ashawkey";
    repo = "kiuikit";
    rev = "refs/tags/${version}";
    hash = "sha256-ubxi7Ri+VYG0cCrKtgzAp7g8JG74i3SAo7no7CYjNVk=";
  };

  nativeBuildInputs = [
    lazy-loader
    varname
    objprint
    setuptools
  ];
  meta = with lib; {
    homepage = "https://github.com/ashawkey/kiuikit";
    description = "A maintained, reusable and trustworthy toolkit for 3D computer vision tasks.";
    license = licenses.asl20;
  };
}
