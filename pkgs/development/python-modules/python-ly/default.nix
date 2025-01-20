{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "python-ly";
  version = "0.9.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zxeA/lPTZ+/B8mQst3xXJGEG6nUX+MLREm8KNu4mVno=";
  };

  # tests not shipped on `pypi` and
  # seem to be broken ATM: https://github.com/wbsoft/python-ly/issues/70
  doCheck = false;

  meta = with lib; {
    description = "Tool and library for manipulating LilyPond files";
    license = licenses.gpl2;
    maintainers = [ ];
  };
}
