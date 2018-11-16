{ stdenv
, buildPythonPackage
, fetchPypi
, tornado
, requests
, httplib2
, sure
, nose
, coverage
, certifi
, urllib3
, isPy3k
}:

buildPythonPackage rec {
  pname = "httpretty";
  version = "0.8.10";
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nmdk6d89z14x3wg4yxywlxjdip16zc8bqnfb471z1365mr74jj7";
  };

  buildInputs = [ tornado requests httplib2 sure nose coverage certifi ];
  propagatedBuildInputs = [ urllib3 ];

  postPatch = ''
    sed -i -e 's/==.*$//' *requirements.txt
    # XXX: Drop this after version 0.8.4 is released.
    patch httpretty/core.py <<DIFF
    ***************
    *** 566 ****
    !                 'content-length': len(self.body)
    --- 566 ----
    !                 'content-length': str(len(self.body))
    DIFF

    # Explicit encoding flag is required with python3, unless locale is set.
    ${if !isPy3k then "" else
      "patch -p0 -i ${./setup.py.patch}"}
  '';

  meta = with stdenv.lib; {
    homepage = "https://falcao.it/HTTPretty/";
    description = "HTTP client request mocking tool";
    license = licenses.mit;
  };

}
