{
  lib,
  fetchPypi,
  buildPythonPackage,
  watchdog,
}:

buildPythonPackage (finalAttrs: {
  pname = "easywatch";
  version = "0.0.5";
  format = "setuptools";

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "1b40cjigv7s9qj8hxxy6yhwv0320z7qywrigwgkasgh80q0xgphc";
  };

  propagatedBuildInputs = [ watchdog ];

  # There are no tests
  doCheck = false;
  pythonImportsCheck = [ "easywatch" ];

  meta = {
    description = "Dead-simple way to watch a directory";
    homepage = "https://github.com/Ceasar/easywatch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
