{
  lib,
  buildPythonPackage,
  fetchPypi,
  chardet,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "binaryornot";
  version = "0.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061";
  };

  prePatch = ''
    # TypeError: binary() got an unexpected keyword argument 'average_size'
    substituteInPlace tests/test_check.py \
      --replace "average_size=512" ""
  '';

  propagatedBuildInputs = [ chardet ];

  nativeCheckInputs = [ hypothesis ];

  meta = with lib; {
    homepage = "https://github.com/audreyr/binaryornot";
    description = "Ultra-lightweight pure Python package to check if a file is binary or text";
    license = licenses.bsd3;
  };
}
