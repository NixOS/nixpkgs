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
  version = "2023.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "moble";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vSkFHYXcT14aW3OTfqYymVQbpWnKFEVkhh3IQTi5xS4=";
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
