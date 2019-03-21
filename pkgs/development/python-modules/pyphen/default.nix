{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Pyphen";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b633a50873156d777e1f1075ba4d8e96a6ad0a3ca42aa3ea9a6259f93f18921";
  };

  meta = with stdenv.lib; {
    description = "Pure Python module to hyphenate text";
    homepage = "https://github.com/Kozea/Pyphen";
    license = with licenses; [gpl2 lgpl21 mpl20];
    maintainers = with maintainers; [ rvl ];
  };
}
