{ stdenv
, buildPythonPackage
, fetchPypi
, pyyaml
}:

buildPythonPackage rec {
  pname = "kaptan";
  version = "0.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b8r86yyvdvyxd6f10mhkl6cr2jhxm80jjqr4zch96w9hs9rh5vq";
  };

  propagatedBuildInputs = [ pyyaml ];

  meta = with stdenv.lib; {
    description = "Configuration manager for python applications";
    homepage = https://emre.github.io/kaptan/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };

}
