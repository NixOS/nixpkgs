{ stdenv
, buildPythonPackage
, fetchFromGitHub
, nose
, six
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "parsimonious";

  src = fetchFromGitHub {
    repo = "parsimonious";
    owner = "erikrose";
    rev = version;
    sha256 = "087npc8ccryrxabmqifcz56w4wd0hzmv0mc91wrbhc1sil196j0a";
  };

  propagatedBuildInputs = [ nose six ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/erikrose/parsimonious";
    description = "Fast arbitrary-lookahead parser written in pure Python";
    license = licenses.mit;
  };

}
