{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, funcsigs
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.9";

  src = fetchPypi {
    inherit version;
    pname = "Pint";
    sha256 = "32d8a9a9d63f4f81194c0014b3b742679dce81a26d45127d9810a68a561fe4e2";
  };

  propagatedBuildInputs = lib.optional isPy27 funcsigs;

  meta = with lib; {
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = [ maintainers.costrouc ];
  };

}
