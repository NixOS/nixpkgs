{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "phonemes2ids";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e3e9e0723215c7187b56276bb053688a43851d8deb9948432e793262551c2ac";
  };

  meta = with lib; {
    description = "Convert phonemes to integer ids";
    homepage = https://github.com/rhasspy/phonemes2ids;
    license = licenses.mit;
    maintainers = [ maintainers.tilcreator ];
  };
}
