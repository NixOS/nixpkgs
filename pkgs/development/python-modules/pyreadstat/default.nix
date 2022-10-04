{ lib, buildPythonPackage, fetchFromGitHub, cython, zlib, pandas, readstat }:

buildPythonPackage rec {
  pname = "pyreadstat";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "Roche";
    repo = "pyreadstat";
    rev = "v${version}";
    sha256 = "16aa16ybh3ikmlxsg8zm19x9k6r4gpd0sxqagv318w76jjyw1nrs";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    readstat
    pandas
  ];

  meta = {
    homepage = "https://github.com/Roche/pyreadstat";
    description = "Python package to read SAS, SPSS and Stata files into pandas data frames using the readstat C library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ swflint ];
  };

}
