{ stdenv, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "PyTado";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = pname;
    # Upstream hasn't tagged this release yet. This commit fixes the build.
    rev = "79a5dfdf75cd9a3e1a1ee8a8ff0d08923aebda7b";
    sha256 = "14xdfw4913g4j4h576hjbigm7fiw8k0dc8s98gh2ag9xrc2ifgr0";
  };

  meta = with stdenv.lib; {
    description = "Python binding for Tado web API. Pythonize your central heating!";
    homepage = https://github.com/wmalgadey/PyTado;
    license = licenses.gpl3;
    maintainers = with maintainers; [ elseym ];
  };
}
