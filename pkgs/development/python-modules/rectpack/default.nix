{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rectpack";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "secnot";
    repo = "rectpack";
    rev = version;
    hash = "sha256-kU0TT3wiudcLXrT+lYPYHYRtf7aNj/IKpnYKb/H91ng=";
  };

  build-system = [ setuptools ];

  # tests are base on nose
  doCheck = false;

  pythonImportsCheck = [ "rectpack" ];

  meta = with lib; {
    description = "Collection of algorithms for solving the 2D knapsack problem";
    homepage = "https://github.com/secnot/rectpack";
    license = licenses.asl20;
    maintainers = with maintainers; [ fbeffa ];
  };
}
