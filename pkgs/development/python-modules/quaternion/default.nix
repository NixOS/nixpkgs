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
  version = "2023.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "moble";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-i+UPi+DrhItplfc6EvDhmr3CEH2/cHODoHVBElM7jY8=";
  };

  propagatedBuildInputs = [
    oldest-supported-numpy
    numba
    scipy
  ];

  meta = {
    description = "Package add built-in support for quaternions to numpy";
    homepage = "https://github.com/moble/quaternion";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ocfox ];
  };
}
