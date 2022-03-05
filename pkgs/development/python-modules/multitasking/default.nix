{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "multitasking";
  version = "0.0.10";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    sha256 = "810640fa6670be41f4a712b287d9307a14ad849d966f06a17d2cf1593b66c3cd";
  };

  doCheck = false;  # No tests included
  pythonImportsCheck = [ "multitasking" ];

  meta = with lib; {
    description = "Non-blocking Python methods using decorators";
    homepage = "https://github.com/ranaroussi/multitasking";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
