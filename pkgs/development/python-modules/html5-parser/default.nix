{ lib, buildPythonPackage, fetchPypi, pkgs, pkg-config, chardet, lxml, beautifulsoup4 }:

buildPythonPackage rec {
  pname = "html5-parser";
  version = "0.4.11";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hbsW+qPN88bGhC4Mss4CgHy678bjuw87jhjavlEHB2M=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ chardet lxml pkgs.libxml2 ];

  nativeCheckInputs = [ beautifulsoup4 ];

  pythonImportsCheck = [
    "html5_parser"
  ];

  meta = with lib; {
    description = "Fast C based HTML 5 parsing for python";
    homepage = "https://html5-parser.readthedocs.io";
    license = licenses.asl20;
  };
}
