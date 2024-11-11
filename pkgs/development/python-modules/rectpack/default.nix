{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rectpack";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "secnot";
    repo = "rectpack";
    rev = version;
    hash = "sha256-kU0TT3wiudcLXrT+lYPYHYRtf7aNj/IKpnYKb/H91ng=";
  };

  nativeBuildInputs = [ setuptools ];

  # tests are base on nose
  pythonImportsCheck = [ "rectpack" ];

  meta = with lib; {
    description = "A collection of algorithms for solving the 2D knapsack problem";
    homepage = "https://github.com/secnot/rectpack";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
