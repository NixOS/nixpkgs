{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "annexremote";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2be77ae9b9edd0d2818ab6dff7070a05aed2fcc1e5065638aa03eba991b67f17";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/Lykos153/AnnexRemote;
    description = "Helper module to easily develop special remotes for git annex";
    license = licenses.gpl3;
    maintainers = with maintainers; [ poelzi ];
  };
}
