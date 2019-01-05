{ stdenv
, buildPythonPackage
, fetchPypi
, pyyaml
}:

buildPythonPackage rec {
  pname = "kaptan";
  version = "0.5.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44df200d030975650a3a832c13b48cafdeb1a237b23de181d6a2346107e39da3";
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
