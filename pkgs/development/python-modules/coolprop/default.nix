{ lib
, git
, gcc
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, cython
, requests
, jinja2
, pyyaml
}:
buildPythonPackage rec {
  pname = "coolprop";
  version = "6.4.3";
  #format = "other";

  src = fetchFromGitHub {
    owner = "CoolProp";
    repo = "CoolProp";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-VU8DEitcfEIIVAsfBc1XfZDh5tQOWAGtRAk5r9ln/hQ=";
  };

  nativeBuildInputs = [
    cython
    git
    gcc
  ];

  propagatedBuildInputs = [
    setuptools
    wheel
    requests
    jinja2
    pyyaml
  ];

  preBuild = ''
    cd ./wrappers/Python
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/CoolProp/CoolProp";
    description = "Thermophysical properties for the masses";
    license = licenses.mit;
    maintainers = with maintainers; [ larsr ];
  };
}
