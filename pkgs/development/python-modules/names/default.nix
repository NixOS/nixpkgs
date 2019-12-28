{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "names";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wd6lb5d0j1ds3n9phj17493az667fp1v52xzcgkzl1f9wjlcvkj";
  };

  doCheck = false;

  meta = {
    description = "Generate random names";
    homepage = "https://github.com/treyhunner/names";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
