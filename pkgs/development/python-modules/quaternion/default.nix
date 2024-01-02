{ lib
, buildPythonPackage
, fetchFromGitHub
, oldest-supported-numpy
, scipy
, numba
}:

buildPythonPackage rec {
  pname = "quaternion";
  version = "2022.4.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "moble";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iLjVQ6eGwpLQXi8Sr5ShJdXMqYNclGEuq/oxR4ExDLA=";
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
