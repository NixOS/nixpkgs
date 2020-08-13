{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, mock
, setuptools_scm
}:

buildPythonPackage rec {
  version = "2.4.1";
  pname = "humanize";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b4ce2fc1c9d79c63f68009ddf5a12ad238aa78e2fceb256b5aa921763551422";
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
