{ lib
, angr
, buildPythonPackage
, fetchFromGitHub
, progressbar
, pythonOlder
, tqdm
}:

buildPythonPackage rec {
  pname = "angrop";
  version = "9.0.7491";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UWqHNgJ8vUbLK3n9tvwOgHyOyTXsqRJKaAPWQfqi3lo=";
  };

  propagatedBuildInputs = [
    angr
    progressbar
    tqdm
  ];

  postPatch = ''
    # https://github.com/angr/angrop/issues/35
    substituteInPlace setup.py \
      --replace "packages=['angrop']," "packages=find_packages()," \
      --replace "from distutils.core import setup" "from setuptools import find_packages, setup"
  '';

  # Tests have additional requirements, e.g., angr binaries
  # cle is executing the tests with the angr binaries already and is a requirement of angr
  doCheck = false;
  pythonImportsCheck = [ "angrop" ];

  meta = with lib; {
    description = "ROP gadget finder and chain builder";
    homepage = "https://github.com/angr/angrop";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
