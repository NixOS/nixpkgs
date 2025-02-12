{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  oldest-supported-numpy,
  scipy,
  numba,
}:

buildPythonPackage rec {
  pname = "quaternion";
  version = "2024.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "moble";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-3UVqeiGcdsjQQpVRhcDBf1N0XJw+Xe/Pp+4lmGzl8ws=";
  };

  propagatedBuildInputs = [
    oldest-supported-numpy
    numba
    scipy
  ];

  meta = with lib; {
    description = "Package add built-in support for quaternions to numpy";
    homepage = "https://github.com/moble/quaternion";
    license = licenses.mit;
    maintainers = [ maintainers.ocfox ];
  };
}
