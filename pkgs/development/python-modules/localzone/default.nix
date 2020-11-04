{ stdenv
, buildPythonPackage
, fetchFromGitHub
, dnspython
, sphinx
, pytest
}:

buildPythonPackage rec {
  pname = "localzone";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "ags-slc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vzn1vm3zf86l7qncbmghjrwyvla9dc2v8abn8jajbl47gm7r5f7";
  };

  propagatedBuildInputs = [ dnspython sphinx ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A simple DNS library for managing zone files";
    homepage = "https://localzone.iomaestro.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ flyfloh ];
  };
}
