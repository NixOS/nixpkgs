{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "eradicate";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06nhs8wml5f5k96gbq7jl417bmsqnxy8aykpzbzrvm3gmqmaizag";
  };

  meta = with lib; {
    description = "eradicate removes commented-out code from Python files.";
    homepage = https://github.com/myint/eradicate;
    license = [ licenses.mit ];

    maintainers = [ maintainers.mmlb ];
  };
}
