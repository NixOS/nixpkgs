{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
  dominate,
  beautifulsoup4,
  docutils,
  sphinx,
}:

buildPythonPackage rec {
  pname = "alectryon";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00cxzfifvgcf3d3s8lsj1yxcwyf3a1964p86fj7b42q8pa0b4r3i";
  };

  propagatedBuildInputs = [
    pygments
    dominate
    beautifulsoup4
    docutils
    sphinx
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/cpitclaudel/alectryon";
    description = "A collection of tools for writing technical documents that mix Coq code and prose";
    mainProgram = "alectryon";
    license = licenses.mit;
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
