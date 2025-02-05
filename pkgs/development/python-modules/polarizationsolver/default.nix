{
  buildPythonPackage,
  lib,
  fetchFromGitLab,
  numpy,
  scipy,
  periodictable,
  fields,
}:

buildPythonPackage rec {
  pname = "polarizationsolver";
  version = "unstable-2021-11-02";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "reinholdt";
    repo = pname;
    rev = "00424ac4d1862257a55e4b16543f63ace3fe8c22";
    hash = "sha256-LACf8Xw+o/uJ3+PD/DE/o7nwKY7fv3NyYbpjCrTTnBU=";
  };

  # setup.py states version="dev", which is not a valid version string for setuptools
  # There has never been a formal stable release, so let's say 0.0 here.
  postPatch = ''
    substituteInPlace ./setup.py --replace 'version="dev",' 'version="0.0",'
  '';

  propagatedBuildInputs = [
    numpy
    periodictable
    scipy
  ];

  nativeCheckInputs = [ fields ];

  pythonImportsCheck = [ "polarizationsolver" ];

  meta = with lib; {
    description = "Multipole moment solver for quantum chemistry and polarisable embedding";
    homepage = "https://gitlab.com/reinholdt/polarizationsolver";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.sheepforce ];
  };
}
