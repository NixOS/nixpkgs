{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oak";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "thesephist";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-00UanINtrFyjQWiAw1ucB4eEODMr9+wT+99Zy2Oc1j4=";
  };

  vendorSha256 = "sha256-iQtb3zNa57nB6x4InVPw7FCmW7XPw5yuz0OcfASXPD8=";

  meta = with lib; {
    description = "Expressive, simple, dynamic programming language";
    homepage = "https://oaklang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ tejasag ];
  };
}
