{ lib
, buildPythonPackage
, fetchPypi
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "opentypespec";
  version = "1.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fOEHmtlCkFhn1jyIA+CsHIfud7x3PPb7UWQsnrVyDqY=";
  };

  doCheck = true;
  nativeCheckInputs = [
    unittestCheckHook
  ];
  unittestFlagsArray = [ "-s" "test" "-v" ];

  meta = with lib; {
    description = "Python library for OpenType specification metadata";
    homepage = "https://github.com/simoncozens/opentypespec-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}

