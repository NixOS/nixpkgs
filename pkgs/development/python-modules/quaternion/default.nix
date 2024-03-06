{ lib
, buildPythonPackage
, fetchFromGitHub
, oldest-supported-numpy
, scipy
, numba
}:

buildPythonPackage rec {
  pname = "quaternion";
  version = "2023.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "moble";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-G5Xbo6Ns98oqtY/AKz9CE7nt8j2b6+Hv14ZoKtlDCMQ=";
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
