{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "progressbar";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfee5201237ca0e942baa4d451fee8bf8a54065a337fabe7378b8585aeda56a3";
  };

  # invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/progressbar;
    description = "Text progressbar library for python";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
