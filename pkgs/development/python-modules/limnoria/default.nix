{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, git
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2021.10.9";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "907a4a0765ab29ccd1c2247efa0eda7a9bd82d3be3a2ecfdeb9b9e6fbb9aa56e";
  };

  postPatch = ''
    sed -i 's/version=version/version="${version}"/' setup.py
  '';
  buildInputs = [ git ];

  # cannot be imported
  doCheck = false;

  meta = with lib; {
    description = "A modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
  };

}
