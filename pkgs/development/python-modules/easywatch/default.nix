{ lib
, fetchPypi
, buildPythonPackage
, watchdog
}:

buildPythonPackage rec {
  pname = "easywatch";
  version = "0.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b40cjigv7s9qj8hxxy6yhwv0320z7qywrigwgkasgh80q0xgphc";
  };

  propagatedBuildInputs = [ watchdog ];

  # There are no tests
  doCheck = false;
  pythonImportsCheck = [ "easywatch" ];

  meta = with lib; {
    description = "Dead-simple way to watch a directory";
    homepage = "https://github.com/Ceasar/easywatch";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}

