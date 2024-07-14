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
    hash = "sha256-/yhPFGm9ZUAFmYB9LGKE1bJROY5uKIEfX3f9JiKSQQs=";
  };

  meta = with lib; {
    description = "Makes entry_points specified in setup.py load more quickly";
    mainProgram = "fastep";
    homepage = "https://github.com/ninjaaron/fast-entry_points";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nixy ];
  };
}
