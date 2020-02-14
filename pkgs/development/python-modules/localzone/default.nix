{ stdenv
, buildPythonPackage
, fetchFromGitHub
, dnspython
, sphinx
, pytest
}:

buildPythonPackage rec {
  pname = "localzone";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "ags-slc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zziqyhbg8vg901b4hjzzab0paag5cng48vk9xf1hchxk5naf58n";
  };

  propagatedBuildInputs = [ dnspython sphinx ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A simple DNS library for managing zone files";
    homepage = https://localzone.iomaestro.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ flyfloh ];
  };
}
