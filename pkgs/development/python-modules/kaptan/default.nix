{ stdenv
, buildPythonPackage
, fetchPypi
, pyyaml
}:

buildPythonPackage rec {
  pname = "kaptan";
  version = "0.5.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8403d6e48200c3f49cb6d6b3dcb5898aa5ab9d820831655bf9a2403e00cd4207";
  };

  propagatedBuildInputs = [ pyyaml ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Configuration manager for python applications";
    homepage = https://kaptan.readthedocs.io/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jgeerds ];
  };

}
