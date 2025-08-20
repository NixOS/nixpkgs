{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "daff";
  version = "1.3.46";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ItDan9ajJ1tUySapyXsYD5JYqtZRE+oY8/7FLLrc2Bg=";
  };

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "daff" ];

  meta = with lib; {
    description = "Library for comparing tables, producing a summary of their differences, and using such a summary as a patch file";
    homepage = "https://github.com/paulfitz/daff";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ turion ];
  };
}
