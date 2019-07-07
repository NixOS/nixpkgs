{ stdenv
, buildPythonPackage
, fetchPypi
, pyyaml
, pytest
}:

buildPythonPackage rec {
  pname = "kaptan";
  version = "0.5.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2";
  };

  postPatch = ''
    sed -i "s/==.*//g" requirements/test.txt
  '';

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Configuration manager for python applications";
    homepage = https://kaptan.readthedocs.io/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
