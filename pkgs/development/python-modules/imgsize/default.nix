{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "imgsize";
  version = "3.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ojii";
    repo = pname;
    tag = version;
    sha256 = "sha256-i0YCt5jTnDAxnaxKSTloWrQn27yLAvZnghZlCgwZh0Q=";
  };

  meta = with lib; {
    description = "Pure Python image size library";
    homepage = "https://github.com/ojii/imgsize";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ twey ];
  };
}
