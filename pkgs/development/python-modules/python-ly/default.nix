{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "python-ly";
  version = "0.9.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4d2b68eb0ef8073200154247cc9bd91ed7fb2671ac966ef3d2853281c15d7a8";
  };

  # tests not shipped on `pypi` and
  # seem to be broken ATM: https://github.com/wbsoft/python-ly/issues/70
  doCheck = false;

  meta = with lib; {
    description = "Tool and library for manipulating LilyPond files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
