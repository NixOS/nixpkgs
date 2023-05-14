{ lib
, buildPythonPackage
, fetchFromGitHub
, dnspython
, sphinx
, pytest
}:

buildPythonPackage rec {
  pname = "localzone";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "ags-slc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cbiv21yryjqy46av9hbjccks95sxznrx8nypd3yzihf1vkjiq5a";
  };

  propagatedBuildInputs = [ dnspython sphinx ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A simple DNS library for managing zone files";
    homepage = "https://localzone.iomaestro.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ flyfloh ];
  };
}
