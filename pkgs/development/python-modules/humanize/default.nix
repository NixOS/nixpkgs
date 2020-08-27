{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, mock
, setuptools_scm
}:

buildPythonPackage rec {
  version = "2.6.0";
  pname = "humanize";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ee358ea6c23de896b9d1925ebe6a8504bb2ba7e98d5ccf4d07ab7f3b28f3819";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ mock ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/jmoiron/humanize";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };

}
