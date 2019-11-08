{ buildPythonPackage
, fetchPypi
, isPy3k
, lib
}:

buildPythonPackage rec {
  pname = "dictances";
  version = "1.5.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xc89j6n5j9i8jk6qv2y87wcny3aq5g06w26b91z1ycm8mkyayzy";
  };

  # Missing some nixpkgs
  doCheck = false;

  meta = with lib; {
    description = "Distances and divergences between distributions implemented in python";
    homepage = "https://github.com/LucaCappelletti94/dictances";
    license = licenses.mit;
    maintainers = [ maintainers.pamplemousse ];
  };
}
