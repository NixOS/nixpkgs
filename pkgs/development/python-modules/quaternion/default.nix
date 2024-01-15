{ lib
, buildPythonPackage
, fetchFromGitHub
, oldest-supported-numpy
, scipy
, numba
}:

buildPythonPackage rec {
  pname = "quaternion";
  version = "2022.4.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "moble";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-fgyi50purfqUIe7zuz/52K6Sw3TjuvAX0EnzkXD//B4=";
  };

  propagatedBuildInputs = [
    oldest-supported-numpy
    numba
    scipy
  ];

  meta = with lib; {
    description = "A package add built-in support for quaternions to numpy";
    homepage = "https://github.com/moble/quaternion";
    license = licenses.mit;
    maintainers = [ maintainers.ocfox ];
  };
}
