{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "fastentrypoints";
  version = "0.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02s1j8i2dzbpbwgq2a3fiqwm3cnmhii2qzc0k42l0rdxd4a4ya7z";
  };

  meta = with lib; {
    description = "Makes entry_points specified in setup.py load more quickly";
    mainProgram = "fastep";
    homepage = "https://github.com/ninjaaron/fast-entry_points";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nixy ];
  };
}
