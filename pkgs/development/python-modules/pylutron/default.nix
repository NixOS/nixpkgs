{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pylutron";
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xy5XPNOrvdPZMCfa2MYA+xtUcFdGSurW5QYL6H7n2VI=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pylutron" ];

  meta = with lib; {
    description = "Python library for controlling a Lutron RadioRA 2 system";
    homepage = "https://github.com/thecynic/pylutron";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
