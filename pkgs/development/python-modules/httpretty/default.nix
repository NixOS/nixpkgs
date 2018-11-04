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
  version = "0.9.5";
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "543fa2bd9c319bfa1e1de9e37d7c9c08fa926a692b65b0be5df4b2f069fd0ad7";
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
