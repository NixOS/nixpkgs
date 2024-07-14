{
  lib,
  buildPythonPackage,
  fetchPypi,
  defcon,
  fontmath,
  unicodedata2,
  fs,
}:

buildPythonPackage rec {
  pname = "mutatormath";
  version = "3.0.1";

  src = fetchPypi {
    pname = "MutatorMath";
    inherit version;
    hash = "sha256-gSfB/60WRvEalTdSKWxD9diMvVKT//A/CT2RawvBOGQ=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    fontmath
    unicodedata2
    defcon
  ];
  nativeCheckInputs = [
    unicodedata2
    fs
  ];

  meta = with lib; {
    description = "Piecewise linear interpolation in multiple dimensions with multiple, arbitrarily placed, masters";
    homepage = "https://github.com/LettError/MutatorMath";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
