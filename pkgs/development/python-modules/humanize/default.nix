{ stdenv
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  version = "0.5.1";
  pname = "humanize";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19";
  };

  buildInputs = [ mock ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python humanize utilities";
    homepage = https://github.com/jmoiron/humanize;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux; # can only test on linux
  };

}
