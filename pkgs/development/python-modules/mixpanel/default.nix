{ stdenv
, buildPythonPackage
, fetchzip
, pytest
, mock
, six
, isPy3k
}:

buildPythonPackage rec {
  version = "4.0.2";
  pname = "mixpanel";
  disabled = isPy3k;

  src = fetchzip {
    url = "https://github.com/mixpanel/mixpanel-python/archive/${version}.zip";
    sha256 = "0yq1bcsjzsz7yz4rp69izsdn47rvkld4wki2xmapp8gg2s9i8709";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ six ];
  checkPhase = "py.test tests.py";

  meta = with stdenv.lib; {
    homepage = https://github.com/mixpanel/mixpanel-python;
    description = ''This is the official Mixpanel Python library'';
    license = licenses.asl20;
  };

}
