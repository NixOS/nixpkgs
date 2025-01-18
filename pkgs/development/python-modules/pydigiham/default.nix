{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  digiham,
  pycsdr,
  codecserver,
}:

buildPythonPackage rec {
  pname = "pydigiham";
  version = "0.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = "pydigiham";
    rev = version;
    hash = "sha256-kiEvQl3SuDnHI4Fh97AarsszHGFt7tbWBvBRW84Qv18=";
  };

  propagatedBuildInputs = [ digiham ];
  buildInputs = [
    codecserver
    pycsdr
  ];
  # make pycsdr header files available
  preBuild = ''
    ln -s ${pycsdr}/include/${python.libPrefix}/pycsdr src/pycsdr
  '';

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "digiham" ];

  meta = with lib; {
    homepage = "https://github.com/jketterl/pydigiham";
    description = "bindings for the csdr library";
    license = licenses.gpl3Only;
    maintainers = teams.c3d2.members;
  };
}
