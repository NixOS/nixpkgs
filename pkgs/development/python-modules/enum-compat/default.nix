{ lib, buildPythonPackage, fetchFromGitHub, enum34 }:

buildPythonPackage rec {
  pname = "enum-compat";
  version = "0.0.3";

  src = fetchFromGitHub {
     owner = "jstasiak";
     repo = "enum-compat";
     rev = "0.0.3";
     sha256 = "1bgwvi5yvh11yilbarycq06az424hav0ihql225pn61jnnklx1nw";
  };

  propagatedBuildInputs = [ enum34 ];

  meta = with lib; {
    homepage = "https://github.com/jstasiak/enum-compat";
    description = "enum/enum34 compatibility package";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
